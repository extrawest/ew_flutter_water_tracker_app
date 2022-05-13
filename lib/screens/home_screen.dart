import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_event.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_state.dart';
import 'package:water_tracker/routes.dart';

import '../models/user_model.dart';
import '../services/firebase/firestore.dart';

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
          if(state.status == AuthStatus.signedOut){
            Navigator.pushNamedAndRemoveUntil(
                context, loginScreenRoute, (route) => false);
          }
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _dateSelect(),
              Expanded(flex: 4,child: _body()),
              _bottomBar(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<FirestoreDatabase>().addUser(UserModel(
              id: 'k0D6uNEwcMTwEr6xdxMO',
              email: 'email@dsa.da',
              dailyWaterLimit: 2000));
          context.read<FirestoreDatabase>().addWater(DayModel(
              id: 'k0D6uNEwcMTwEr6xdxMO',
              date: '',
              water: [WaterModel(type: 'milk', amount: 200, time: '12:00')]));
          final user = await context
              .read<FirestoreDatabase>()
              .getUser('k0D6uNEwcMTwEr6xdxMO');
          print(user);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _dateSelect() {
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
            onPressed: () {},
          ),
          Column(
            children: const [
              Text('Saturday'),
              Text('7 September, 2019'),
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
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('Todays drinks:'),
            trailing: IconButton(
                onPressed: () {}, icon: const Icon(Icons.info_outlined)),
          ),
          ListView(
            shrinkWrap: true,
            children: const [
              Text('drink'),
              Text('drink'),
              Text('drink'),
            ],
          )
        ],
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
