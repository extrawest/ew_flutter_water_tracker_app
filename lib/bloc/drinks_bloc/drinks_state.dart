import 'package:equatable/equatable.dart';

enum DrinkStatus { initial, success, failure }

class DrinkState extends Equatable {
  final DrinkStatus status;
  final String error;

  const DrinkState({this.status = DrinkStatus.initial, this.error = ''});

  DrinkState copyWith({DrinkStatus? status, String? error}) =>
      DrinkState(status: status ?? this.status, error: error ?? this.error);

  @override
  List<Object?> get props => [status];
}
