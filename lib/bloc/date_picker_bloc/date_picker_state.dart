import 'package:equatable/equatable.dart';


class DatePickerState extends Equatable {
  final String dayOfWeek;
  final String dateInfo;
  final DateTime? date;

  const DatePickerState(
      {this.dayOfWeek = '',
      this.dateInfo = '',
      this.date,});

  DatePickerState copyWith(
          {String? dayOfWeek,
          String? dateInfo,
          DateTime? date,}) =>
      DatePickerState(
          dayOfWeek: dayOfWeek ?? this.dayOfWeek,
          dateInfo: dateInfo ?? this.dateInfo,
          date: date ?? this.date,
      );

  @override
  List<Object?> get props => [dayOfWeek, dateInfo, date];
}
