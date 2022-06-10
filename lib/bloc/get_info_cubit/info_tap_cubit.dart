
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoTapCubit extends Cubit<int> {
  InfoTapCubit() : super(0);

  void tapIncrement() => emit(state + 1);

  void tapClear() => emit(0);
}