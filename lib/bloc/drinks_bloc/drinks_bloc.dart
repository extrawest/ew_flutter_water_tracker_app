import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_event.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_state.dart';

import 'package:water_tracker/models/water_model.dart';
import 'package:water_tracker/repository/firestore_repository.dart';

class DrinksBloc extends Bloc<DrinksEvent, DrinkState> {
  final FirestoreRepository repository;

  DrinksBloc(this.repository) : super(const DrinkState()) {
    on<AddDrink>(_onAddDrink);
    on<DeleteDrink>(_onDeleteDrink);
    on<DrinksOverviewSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onSubscriptionRequested(
      DrinksOverviewSubscriptionRequested event,
      Emitter<DrinkState> emit) async {
    final String date = DateTime.parse(event.date.toString().split(' ')[0])
        .millisecondsSinceEpoch
        .toString();
    await emit.forEach(repository.getDayDoc(date), onData: (DocumentSnapshot water) {
      final Map<String, dynamic> json = water.data() as Map<String, dynamic>;
      final List<WaterModel> waters =
          List<WaterModel>.from(json['water'].map((e) {
        return WaterModel.fromJson(e);
      }));
      return state.copyWith(status: DrinkStatus.success, drinks: waters);
    });
  }

  Future<void> _onAddDrink(AddDrink event, Emitter<DrinkState> emit) async {
    try {
      final WaterModel waterModel =
          WaterModel(amount: event.amount, time: event.time, type: event.type);
      await repository.addWater(waterModel, event.date);
    } catch (err) {
      emit(state.copyWith(status: DrinkStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onDeleteDrink(
      DeleteDrink event, Emitter<DrinkState> emit) async {
    try {
      await repository.deleteWater(event.model, event.date);
      //emit(state.copyWith(status: DrinkStatus.deleted));
    } catch (err) {
      emit(state.copyWith(status: DrinkStatus.failure, error: err.toString()));
    }
  }
}
