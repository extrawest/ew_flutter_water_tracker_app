import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc_barrel.dart';
import 'package:water_tracker/common/extensions/datetime_to_milliseconds_to_string.dart';

import 'package:water_tracker/models/water_model.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/services/firebase/crashlytics_service.dart';
import 'package:water_tracker/services/firebase/remote_config_service.dart';

class DrinksBloc extends Bloc<DrinksEvent, DrinkState> {
  final FirestoreRepository repository;
  final CrashlyticsService crashlyticsService;
  final RemoteConfigService remoteConfigService;

  DrinksBloc({required this.repository, required this.crashlyticsService, required this.remoteConfigService})
      : super(const DrinkState()) {
    on<AddDrink>(_onAddDrink);
    on<DeleteDrink>(_onDeleteDrink);
    on<DrinksOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<LoadDailyLimit>(_onLoadDailyLimit);
    on<CountOverall>(_onCountOverall);
    on<FetchIndicatorType>(_onFetchIndicatorType);
  }

  Future<void> _onSubscriptionRequested(
      DrinksOverviewSubscriptionRequested event,
      Emitter<DrinkState> emit) async {
    final String date = event.date.toMillisecondsString();

    await emit.forEach(repository.getDayDoc(date),
        onData: (DocumentSnapshot<List<WaterModel>> water) {
      final List<WaterModel>? waters = water.data();
      add(CountOverall());
      return state.copyWith(status: DrinkStatus.success, drinks: waters ?? []);
    }, onError: (_, __) {
      crashlyticsService.recError('failed to subscribe on day document');
      return state.copyWith(status: DrinkStatus.failure);
    });
  }

  Future<void> _onAddDrink(AddDrink event, Emitter<DrinkState> emit) async {
    try {
      final WaterModel waterModel =
          WaterModel(amount: event.amount, time: event.time, type: event.type);
      await repository.addWater(waterModel, event.date.toMillisecondsString());
    } catch (err) {
      crashlyticsService.recError(err.toString());
      emit(state.copyWith(status: DrinkStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onDeleteDrink(
      DeleteDrink event, Emitter<DrinkState> emit) async {
    try {
      await repository.deleteWater(
          event.model, event.date.toMillisecondsString());
    } catch (err) {
      crashlyticsService.recError(err.toString());
      emit(state.copyWith(status: DrinkStatus.failure, error: err.toString()));
    }
  }

  void _onCountOverall(CountOverall event, Emitter<DrinkState> emit) {
    int drunkWater = 0;
    final drinks = state.drinks;
    for (final i in drinks) {
      drunkWater += i.amount;
    }
    emit(state.copyWith(drunkWater: drunkWater));
  }

  Future<void> _onLoadDailyLimit(
      LoadDailyLimit event, Emitter<DrinkState> emit) async {
    try {
      emit(state.copyWith(status: DrinkStatus.loading));
      final dailyLimit = await repository.getDailyLimit();
      emit(state.copyWith(
          dailyWaterLimit: dailyLimit, status: DrinkStatus.success));
    } catch (err) {
      crashlyticsService.recError(err.toString());
      emit(state.copyWith(status: DrinkStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onFetchIndicatorType(
      FetchIndicatorType event, Emitter<DrinkState> emit) async {
    final indicatorType = remoteConfigService.getRemoteConfig.getString('progress_indicator_type');
    emit(state.copyWith(progressType: indicatorType));
  }
}
