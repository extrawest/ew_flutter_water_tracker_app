import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:water_tracker/bloc/home_cubit/home_cubit.dart';

class DrinksOverall extends StatelessWidget {
  const DrinksOverall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 35,
              percent: 0.6,
              animation: true,
              backgroundWidth: 45,
              linearGradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xff50b3fb),
                  Color(0xff0082fa),
                ],
              ),
              curve: Curves.easeInOut,
              circularStrokeCap: CircularStrokeCap.round,
              center: _centerData(context),
            ),
          ),
          TextButton(
            onPressed: (){
              context.read<HomeCubit>().setTab(HomeTab.drinks);
            },
            child: const Text("Today's drinks"),
          ),
        ],
      ),
    );
  }

  Widget _centerData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text('done'),
        Text('2000'),
        Text('of 3000ml'),
      ],
    );
  }
}
