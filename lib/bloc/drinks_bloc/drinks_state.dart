import 'package:equatable/equatable.dart';
import 'package:water_tracker/models/water_model.dart';

enum DrinkStatus { initial, loading, success, failure, deleted }

class DrinkState extends Equatable {
  final DrinkStatus status;
  final String error;
  final List<WaterModel> drinks;
  final int drunkWater;
  final int dailyWaterLimit;
  final String progressType;

  const DrinkState(
      {this.status = DrinkStatus.initial,
      this.error = '',
      this.drinks = const [],
      this.dailyWaterLimit = 0,
      this.drunkWater = 0,
      this.progressType = ''});

  DrinkState copyWith(
          {DrinkStatus? status,
          String? error,
          List<WaterModel>? drinks,
          int? dailyWaterLimit,
          int? drunkWater,
          String? progressType}) =>
      DrinkState(
          status: status ?? this.status,
          error: error ?? this.error,
          drinks: drinks ?? this.drinks,
          dailyWaterLimit: dailyWaterLimit ?? this.dailyWaterLimit,
          drunkWater: drunkWater ?? this.drunkWater,
          progressType: progressType ?? this.progressType);

  @override
  List<Object?> get props =>
      [status, error, drinks, dailyWaterLimit, drunkWater, progressType];
}
