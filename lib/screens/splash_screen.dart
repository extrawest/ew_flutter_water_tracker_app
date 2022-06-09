import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/dynamic_link_bloc/dynamic_link_barrel.dart';
import 'package:water_tracker/common/app_constants.dart';
import 'package:water_tracker/routes.dart';
import 'package:water_tracker/services/firebase/remote_config_service.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      await RemoteConfigService().setupRemoteConfig();
      context.read<DynamicLinkBloc>().add(GetDynamicLink());
      final user = FirebaseAuth.instance.currentUser;
        Navigator.pushReplacementNamed(context, user == null ? loginScreenRoute : homeScreenRoute);
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
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              width: 100,
              child: Image.asset(ImagesPath.DROP_IMAGE),
            ),
          ],
        ),
      ),
    );
  }
}
