import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:water_tracker/models/user_model.dart';

abstract class DrinksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddDrink extends DrinksEvent {
  final String time;
  final int amount;
  final String type;
  final String date;

  AddDrink(
      {required this.time,
      required this.date,
      required this.type,
      required this.amount});
}

class LoadDrinks extends DrinksEvent {
  final DocumentSnapshot snapshot;

  LoadDrinks(this.snapshot);
}

class DeleteDrink extends DrinksEvent {
  final WaterModel model;

  DeleteDrink(this.model);
}
