import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_bloc_barrel.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc_barrel.dart';
import 'package:water_tracker/bloc/home_cubit/home_cubit.dart';
import 'package:water_tracker/models/water_model.dart';
import 'package:water_tracker/widgets/empty_drinks_list.dart';

class DrinksList extends StatelessWidget {
  const DrinksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrinksBloc, DrinkState>(builder: (context, drinkState) {
      if(drinkState.status == DrinkStatus.loading){
        return const Center(child: CircularProgressIndicator(),);
      }
      if(drinkState.drinks.isEmpty){
        return const EmptyDrinksList();
      }
      return Column(
        children: [
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListView(shrinkWrap: true, children: [
                ListTile(
                  title: const Text("Today's drinks:"),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.info_outlined)),
                ),
                ...drinkState.drinks.map((water) => Dismissible(
                      background: Container(
                        color: Colors.red,
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _deleteDrink(water, context);
                      },
                      key: UniqueKey(),
                      child: ListTile(
                        title: Text(water.type),
                        subtitle: Text(water.time),
                        trailing: Text('${water.amount}ml'),
                      ),
                    ))
              ]),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<HomeCubit>().setTab(HomeTab.progress);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
            ),
            child: const Text('Overall volume'),
          ),
        ],
      );
    });
  }

  void _deleteDrink(WaterModel water, BuildContext context) {
    context.read<DrinksBloc>().add(DeleteDrink(
        model: water, date: context.read<DatePickerBloc>().state.date!));
  }
}
