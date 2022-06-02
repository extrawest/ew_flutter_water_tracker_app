import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('${message.data}');
}

class CloudMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessaging get fcmInstance => _firebaseMessaging;

  Future<String?> get fcmToken async => await _firebaseMessaging.getToken();

  Future<void> subscribeTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }
}
