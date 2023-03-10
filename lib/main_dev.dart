import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:water_tracker/app.dart';
import 'package:water_tracker/app_config.dart';
import 'package:water_tracker/localization/translate_preferences.dart';
import 'package:water_tracker/services/firebase/cloud_messaging_service.dart';


import 'utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  setupLogger();

  final configuredApp = AppConfig(
    appName: 'DEV Water Tracker',
    flavorName: 'dev',
    apiUrl: 'jsonplaceholder.typicode.com',
    child: Application(),
  );

  final delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en',
      preferences: TranslatePreferences(),
      supportedLocales: [
        'en',
        'uk',
      ]);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(LocalizedApp(delegate, configuredApp));
}
