import 'package:flutter/material.dart';
import 'package:water_tracker/screens/login_screen.dart';
import 'package:water_tracker/screens/profile_screen.dart';
import 'package:water_tracker/screens/register_screen.dart';

import 'flavor_banner.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

const String homeScreenRoute = '/home_screen';
const String splashScreenRoute = '/splash_screen';
const String registerScreenRoute = '/register_screen';
const String loginScreenRoute = '/login_screen';
const String profileScreenRoute = '/profile_screen';

Map<String, WidgetBuilder> applicationRoutes = <String, WidgetBuilder>{
  splashScreenRoute: (context) => SplashScreen(),
  homeScreenRoute: (context) => const FlavorBanner(child: HomeScreenWrapper()),
  registerScreenRoute: (context) => const RegisterScreen(),
  loginScreenRoute: (context) => const LoginScreen(),
  profileScreenRoute: (context) => const ProfileScreenWrapper(),
};
