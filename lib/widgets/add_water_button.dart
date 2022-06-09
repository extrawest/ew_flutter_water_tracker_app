import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_bloc_barrel.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc_barrel.dart';
import 'package:water_tracker/popup/add_water_popup.dart';
import 'package:water_tracker/popup/popup_layout.dart';

class AddWaterButton extends StatelessWidget {
  const AddWaterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.blue,
                    spreadRadius: 0.3,
                    blurRadius: 10,
                    offset: Offset(0, 5))
              ],
          ),
          child: Material(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              highlightColor: Colors.blueAccent.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                    context,
                    PopupLayout(
                          child: MultiBlocProvider(providers: [
                              BlocProvider.value(
                                value: context.read<DatePickerBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<DrinksBloc>(),
                              )
                            ], child: const AddWaterPopup()),
                        top: 170,
                        bottom: 170));
              },
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ));
  }
}
