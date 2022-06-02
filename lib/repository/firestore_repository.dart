import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/models/water_model.dart';
import 'package:water_tracker/services/firebase/cloud_messaging_service.dart';
import 'package:water_tracker/services/firebase/firestore.dart';

abstract class FirestoreRepository {
  Future<void> addUser(UserModel model);

  Future<void> addWater(WaterModel waterModel, String date);

  Future<UserModel> getUser();

  Future<void> updateUsername(String name);

  Future<int> getDailyLimit();

  Future<void> updateDailyLimit(int dailyWaterLimit);

  Future<void> deleteWater(WaterModel waterModel, String date);

  Future<void> setFcmToken();

  Stream<DocumentSnapshot<List<WaterModel>>> getDayDoc(String date);
}

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreDatabase firestoreDatabase;
  final CloudMessagingService cloudMessagingService;

  FirestoreRepositoryImpl(
      {required this.firestoreDatabase, required this.cloudMessagingService});

  @override
  Future<void> addUser(UserModel model) async {
    await firestoreDatabase.addUser(model);
  }

  @override
  Future<void> addWater(WaterModel waterModel, String date) async {
    await firestoreDatabase.addWater(waterModel, date);
  }

  @override
  Future<UserModel> getUser() async {
    return await firestoreDatabase.getUser();
  }

  @override
  Future<void> updateUsername(String name) async {
    await firestoreDatabase.updateUsername(name);
  }

  @override
  Future<int> getDailyLimit() async {
    return await firestoreDatabase.getDailyLimit();
  }

  @override
  Future<void> updateDailyLimit(int dailyWaterLimit) async {
    await firestoreDatabase.updateDailyLimit(dailyWaterLimit);
  }

  @override
  Future<void> deleteWater(WaterModel waterModel, String date) async {
    return await firestoreDatabase.deleteWater(waterModel, date);
  }

  @override
  Stream<DocumentSnapshot<List<WaterModel>>> getDayDoc(String date) {
    return firestoreDatabase.getDayDoc(date);
  }

  @override
  Future<void> setFcmToken() async {
    final token = await cloudMessagingService.fcmToken;
    await firestoreDatabase.setUserToken(token!);
  }
}
