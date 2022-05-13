import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:water_tracker/routes.dart';

import '../services/firebase/firebase_authentication.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {

      AuthService().firebaseAuth
          .authStateChanges().listen((User? user) {
        Navigator.pushReplacementNamed(context, user == null ? loginScreenRoute : homeScreenRoute);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Water Tracker',
              style: TextStyle(
                  fontSize: 28,
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
            SizedBox(
              width: 100,
              child: Image.asset('assets/images/drop.png'),
            ),
          ],
        ),
      ),
    );
  }
}
