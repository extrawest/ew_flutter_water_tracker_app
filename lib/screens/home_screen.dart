import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_event.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_state.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_event.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_bloc.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_event.dart';
import 'package:water_tracker/bloc/drinks_bloc/drinks_state.dart';
import 'package:water_tracker/popup/add_water_popup.dart';
import 'package:water_tracker/popup/popup_layout.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/routes.dart';

import '../bloc/date_picker_bloc/date_picker_bloc.dart';
import '../bloc/date_picker_bloc/date_picker_state.dart';
import '../services/firebase/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _datePickerBloc = DatePickerBloc()
    ..add(DatePickerSelectDate(
        DateTime.parse(DateTime.now().toString().split(' ')[0])));

  //final _drinksBloc = DrinksBloc(FirestoreRepositoryImpl(FirestoreDatabase()));

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DrinksBloc>(
          create: (context) =>
              DrinksBloc(FirestoreRepositoryImpl(FirestoreDatabase())),
        ),
        BlocProvider<DatePickerBloc>.value(value: _datePickerBloc),
      ],
      child: Scaffold(
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
      ),
    );
  }

  Widget _dateSelect() {
    return BlocBuilder<DatePickerBloc, DatePickerState>(
        bloc: _datePickerBloc,
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
                      initialDate: state.date ??
                          DateTime.parse(
                              DateTime.now().toString().split(' ')[0]),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((date) {
                      _datePickerBloc.add(DatePickerSelectDate(date!));
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
    return BlocBuilder<DatePickerBloc, DatePickerState>(
        bloc: _datePickerBloc,
        builder: (context, dateState) => Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Today's drinks:"),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.info_outlined)),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirestoreDatabase().getDayDoc(
                          '${dateState.date?.millisecondsSinceEpoch}'),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data?.data() == null) {
                          return const Text('No drinks added today');
                        } else {
                          context
                              .read<DrinksBloc>()
                              .add(LoadDrinks(snapshot.data!));
                          return BlocBuilder<DrinksBloc, DrinkState>(
                              builder: (context, drinkState) => Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: ListView(
                                        shrinkWrap: true,
                                        children: drinkState.drinks
                                            .map(
                                              (water) => Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(water.type),
                                                          Text(water.time),
                                                        ],
                                                      ),
                                                      Text('${water.amount}ml'),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    color: Colors.black12,
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList()),
                                  ));
                        }
                      }),
                ],
              ),
            ));
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
                      context.read<AuthBloc>().add(AuthLogOut());
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
