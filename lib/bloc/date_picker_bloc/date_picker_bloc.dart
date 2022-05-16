import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_event.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_state.dart';

const Map<int, String> weekDays = {
  1: 'Monday',
  2: 'Tuesday',
  3: 'Wednesday',
  4: 'Thursday',
  5: 'Friday',
  6: 'Saturday',
  7: 'Sunday',
};

const Map<int, String> months = {
  1: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'September',
  10: 'October',
  11: 'November',
  12: 'December',
};

class DatePickerBloc extends Bloc<DatePickerEvent, DatePickerState> {
  DatePickerBloc() : super(const DatePickerState()) {
    on<DatePickerSelectDate>(_onDatePickerSelectDate);
  }

  void _onDatePickerSelectDate(
      DatePickerSelectDate event, Emitter<DatePickerState> emit) {
    return emit(state.copyWith(
        dayOfWeek: _getDayOfWeek(event.dateTime.weekday),
        dateInfo: _getFormattedDate(event.dateTime),
        date: event.dateTime));
  }

  String? _getDayOfWeek(int weekDay) {
    return weekDays[weekDay];
  }

  String? _getFormattedDate(DateTime dateTime) {
    return '${dateTime.day} ${months[dateTime.month]}, ${dateTime.year}';
  }
}
