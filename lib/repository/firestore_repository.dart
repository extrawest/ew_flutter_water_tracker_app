import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/models/water_model.dart';
import 'package:water_tracker/services/firebase/firestore.dart';

abstract class FirestoreRepository {
  Future<void> addUser(UserModel model);

  Future<void> addWater(WaterModel waterModel, String date);

  Future<UserModel> getUser();

  Future<void> updateUsername(String name);

  Future<void> updateDailyLimit(int dailyWaterLimit);

  Future<void> deleteWater(WaterModel waterModel, String date);

  Stream<DocumentSnapshot<List<WaterModel>>> getDayDoc(String date);
}

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreDatabase _firestoreDatabase;

  FirestoreRepositoryImpl(this._firestoreDatabase);

  @override
  Future<void> addUser(UserModel model) async {
    await _firestoreDatabase.addUser(model);
  }

  @override
  Future<void> addWater(WaterModel waterModel, String date) async {
    await _firestoreDatabase.addWater(waterModel, date);
  }

  @override
  Future<UserModel> getUser() async {
    return await _firestoreDatabase.getUser();
  }

  @override
  Future<void> updateUsername(String name) async {
    await _firestoreDatabase.updateUsername(name);
  }

  @override
  Future<void> updateDailyLimit(int dailyWaterLimit) async {
    await _firestoreDatabase.updateDailyLimit(dailyWaterLimit);
  }

  @override
  Future<void> deleteWater(WaterModel waterModel, String date) async {
    return await _firestoreDatabase.deleteWater(waterModel, date);
  }

  @override
  Stream<DocumentSnapshot<List<WaterModel>>> getDayDoc(String date) {
    return _firestoreDatabase.getDayDoc(date);
  }
}