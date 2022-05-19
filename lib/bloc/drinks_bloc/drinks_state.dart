import 'package:equatable/equatable.dart';
import 'package:water_tracker/models/water_model.dart';

enum DrinkStatus { initial, success, failure }

class DrinkState extends Equatable {
  final DrinkStatus status;
  final String error;
  final List<WaterModel> drinks;

  const DrinkState(
      {this.status = DrinkStatus.initial,
      this.error = '',
      this.drinks = const []});

  DrinkState copyWith(
          {DrinkStatus? status, String? error, List<WaterModel>? drinks}) =>
      DrinkState(
          status: status ?? this.status,
          error: error ?? this.error,
          drinks: drinks ?? this.drinks);

  @override
  List<Object?> get props => [status, error, drinks];
}
