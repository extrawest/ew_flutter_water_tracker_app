import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'firebase_authentication.dart';

class CrashlyticsService {
  final FirebaseCrashlytics _crashlyticsService = FirebaseCrashlytics.instance;

  StreamSubscription<User?> listenAuthState(AuthService firebaseAuth) {
    return firebaseAuth.authState.listen((firebaseUser) {
      if (firebaseUser != null) {
        _crashlyticsService.setUserIdentifier(firebaseUser.uid);
      }
    });
  }


  Future<void> recError(String exception, StackTrace trace, {String? reason}) async {
    await _crashlyticsService.recordError(exception, trace, reason: reason);
  }
}