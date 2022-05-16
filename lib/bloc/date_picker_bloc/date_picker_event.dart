import 'package:equatable/equatable.dart';

abstract class DatePickerEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class DatePickerSelectDate extends DatePickerEvent {
  final DateTime dateTime;

  DatePickerSelectDate(this.dateTime);
}
