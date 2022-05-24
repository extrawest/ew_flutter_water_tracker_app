import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_barrel.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_bloc_barrel.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc_barrel.dart';
import 'package:water_tracker/popup/add_water_popup.dart';
import 'package:water_tracker/popup/popup_layout.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/routes.dart';
import 'package:water_tracker/widgets/drinks_list.dart';


class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DatePickerBloc>(
          create: (context) =>
              DatePickerBloc()..add(DatePickerSelectDate(DateTime.now())),
        ),
        BlocProvider<DrinksBloc>(
          create: (context) =>
              DrinksBloc(context.read<FirestoreRepositoryImpl>()),
        ),
      ],
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.signedOut) {
            Navigator.pushNamedAndRemoveUntil(
                context, loginScreenRoute, (route) => false);
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _dateSelect(),
              Expanded(flex: 4, child: _body()),
              _bottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateSelect() {
    return BlocBuilder<DatePickerBloc, DatePickerState>(
        builder: (context, state) {
      return Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: state.date ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((date) {
                  context
                      .read<DatePickerBloc>()
                      .add(DatePickerSelectDate(date!));
                });
              },
            ),
            Column(
              children: [
                Text(state.dayOfWeek),
                Text(state.dateInfo),
              ],
            ),
            Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {},
              ),
              const VerticalDivider(),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {},
              ),
            ]),
          ],
        ),
      );
    });
  }

  Widget _body() {
    return BlocListener<DatePickerBloc, DatePickerState>(
        listenWhen: (previousState, state) {
          if (previousState.date != state.date) {
            return true;
          } else {
            return false;
          }
        },
        listener: (context, state) {
          context
              .read<DrinksBloc>()
              .add(DrinksOverviewSubscriptionRequested(state.date!));
        },
        child: Container(
            margin: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const DrinksList()));
  }

  Widget _bottomBar() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.stacked_bar_chart),
                    onPressed: () {},
                  ),
                  const SizedBox(),
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, profileScreenRoute);
                    },
                  ),
                ],
              ),
            ),
            Align(
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
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xff50b3fb),
                          Color(0xff0082fa),
                        ],
                      )),
                  child: IconButton(
                      onPressed: () {
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
                      icon: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 40,
                      ))),
            ),
          ],
        ),
      );
    });
  }

}
