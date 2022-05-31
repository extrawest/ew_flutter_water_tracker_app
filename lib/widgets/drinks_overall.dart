import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc_barrel.dart';
import 'package:water_tracker/bloc/home_cubit/home_cubit.dart';

class DrinksOverall extends StatefulWidget {
  const DrinksOverall({Key? key}) : super(key: key);

  @override
  State<DrinksOverall> createState() => _DrinksOverallState();
}

class _DrinksOverallState extends State<DrinksOverall> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrinksBloc, DrinkState>(builder: (context, state) {
      return Center(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: CircularPercentIndicator(
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
              ),
            ),
            TextButton(
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
        Text('${state.dailyWaterLimit}'),
      ],
    );
  }
}
