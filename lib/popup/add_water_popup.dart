import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_bloc.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_event.dart';

class AddWaterPopup extends StatefulWidget {
  const AddWaterPopup({Key? key}) : super(key: key);

  @override
  _AddWaterPopupState createState() => _AddWaterPopupState();
}

class _AddWaterPopupState extends State<AddWaterPopup> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedTime = '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _form(context),
          _buttons(context),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              const Text('Select time'),
              TextButton(
                child: Text(_selectedTime),
                onPressed: () async {
                  final result = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, widget) {
                        return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: widget!);
                      });
                  if (result != null) {
                    setState(() {
                      _selectedTime =
                      '${result.hour.toString()}:${result.minute.toString()}';
                    });
                  }
                },
              ),
            ],
          ),
          TextFormField(
            controller: _typeController,
            decoration: const InputDecoration(
              hintText: 'Input type (e.g. water, milk)',
            ),
            validator: (value) {
              if (value == '') {
                return 'Input type';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              hintText: 'Input amount in ml',
            ),
            validator: (value) {
              if (RegExp(r'^[0-9]+$').hasMatch(value!)) {
                return null;
              } else if (value == '') {
                return 'Input amount';
              } else {
                return 'Amount field must contain only digits (f.e 300)';
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _addDrink();
                Navigator.pop(context);
              }
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _addDrink() {
    context.read<DrinksBloc>().add(AddDrink(
        time: _selectedTime,
        date: context.read<DatePickerBloc>().state.date!,
        type: _typeController.text,
        amount: int.parse(_amountController.text)));
  }
}