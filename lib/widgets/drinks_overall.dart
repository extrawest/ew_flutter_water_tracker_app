import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc_barrel.dart';
import 'package:water_tracker/bloc/home_cubit/home_cubit.dart';

class DrinksOverall extends StatefulWidget {
  const DrinksOverall({Key? key}) : super(key: key);

  @override
  State<DrinksOverall> createState() => _DrinksOverallState();
}

class _DrinksOverallState extends State<DrinksOverall> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrinksBloc, DrinkState>(builder: (context, state) {
      return Center(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: state.progressType == 'circular'
                  ? _circleIndicator(state)
                  : _linearIndicator(state),
            ),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              ),
              onPressed: () {
                context.read<HomeCubit>().setTab(HomeTab.drinks);
              },
              child: const Text("Today's drinks"),
            ),
          ],
        ),
      );
    });
  }

  Widget _centerData(BuildContext context, DrinkState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('done'),
        Text('${state.drunkWater}'),
        Text('of ${state.dailyWaterLimit} ml'),
      ],
    );
  }

  Widget _linearIndicator(DrinkState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearPercentIndicator(
          percent: state.dailyWaterLimit == 0
              ? 0
              : state.drunkWater / state.dailyWaterLimit,
          barRadius: const Radius.circular(16),
          lineHeight: 30.0,
          animation: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          curve: Curves.easeInOut,
          linearGradient: const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: <Color>[
              Color(0xff50b3fb),
              Color(0xff0082fa),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text('${state.drunkWater} done of ${state.dailyWaterLimit}ml'),
        ),
      ],
    );
  }

  Widget _circleIndicator(DrinkState state) {
    return CircularPercentIndicator(
      radius: 150.0,
      lineWidth: 35,
      percent: state.dailyWaterLimit == 0
          ? 0
          : state.drunkWater / state.dailyWaterLimit,
      animation: true,
      backgroundWidth: 45,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      center: _centerData(context, state),
    );
  }
}
