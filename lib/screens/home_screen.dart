import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_event.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_state.dart';
import 'package:water_tracker/bloc/date_picker_bloc/date_picker_event.dart';
import 'package:water_tracker/routes.dart';

import '../bloc/date_picker_bloc/date_picker_bloc.dart';
import '../bloc/date_picker_bloc/date_picker_state.dart';
import '../models/user_model.dart';
import '../services/firebase/firestore.dart';

// class SetHomeScreen extends StatelessWidget {
//   const SetHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//         providers: [
//
//         ],
//         child: const HomeScreen());
//   }
// }


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _datePickerBloc = DatePickerBloc()
    ..add(DatePickerSelectDate(DateTime.parse(DateTime.now().toString().split(' ')[0])));

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // FirestoreDatabase().addUser(UserModel(
          //     id: 'k0D6uNEwcMTwEr6xdxMO',
          //     email: 'email@dsa.da',
          //     dailyWaterLimit: 2000));
          FirestoreDatabase().addWater(
              WaterModel(type: 'milk', amount: 250, time: '13:50'),
              '${_datePickerBloc.state.date?.microsecondsSinceEpoch}');
          // final user = await context
          //     .read<FirestoreDatabase>()
          //     .getUser('k0D6uNEwcMTwEr6xdxMO');
        },
        child: const Icon(Icons.add),
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
                      initialDate: state.date ?? DateTime.parse(DateTime.now().toString().split(' ')[0]),
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
      builder: (context, state) => Container(
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
                  onPressed: () {}, icon: const Icon(Icons.info_outlined)),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('days')
                    .doc('${state.date?.microsecondsSinceEpoch}')
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.data!.data() == null) {
                    return const Text('No drinks added today');
                  }
                  return Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ListView(
                        shrinkWrap: true,
                        children: DayModel.fromJson(
                                snapshot.data!.data() as Map<String, dynamic>)
                            .water!
                            .map(
                              (water) => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
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
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogOut());
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
