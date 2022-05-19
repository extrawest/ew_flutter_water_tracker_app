import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_event.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_state.dart';

import 'package:water_tracker/models/water_model.dart';
import 'package:water_tracker/repository/firestore_repository.dart';

class DrinksBloc extends Bloc<DrinksEvent, DrinkState> {
  final FirestoreRepository repository;

  DrinksBloc(this.repository) : super(const DrinkState()) {
    on<AddDrink>(_onAddDrink);
    on<LoadDrinks>(_onLoadDrinks);
  }

  Future<void> _onAddDrink(AddDrink event, Emitter<DrinkState> emit) async {
    try {
      final WaterModel waterModel =
          WaterModel(amount: event.amount, time: event.time, type: event.type);
      await repository.addWater(waterModel, event.date);
      emit(state.copyWith(status: DrinkStatus.success));
    } catch (err) {
      emit(state.copyWith(status: DrinkStatus.failure, error: err.toString()));
    }
  }

  void _onLoadDrinks(LoadDrinks event, Emitter<DrinkState> emit) {
    final Map<String, dynamic> json =
        event.snapshot.data() as Map<String, dynamic>;
    final List<WaterModel> waters =
        List<WaterModel>.from(json['water'].map((e) => WaterModel.fromJson(e)));
    emit(state.copyWith(drinks: waters));
  }
}
