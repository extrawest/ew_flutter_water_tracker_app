import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/models/water_model.dart';
import 'package:water_tracker/services/firebase/firestore.dart';

abstract class FirestoreRepository {
  Future<void> addUser(UserModel model);

  Future<void> addWater(WaterModel waterModel, String date);

  Future<UserModel> getUser(String id);

  Future<void> deleteWater(WaterModel waterModel, String date);

  Stream<DocumentSnapshot> getDayDoc(String date);
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
  Future<UserModel> getUser(String id) async {
    return await _firestoreDatabase.getUser(id);
  }

  @override
  Future<void> deleteWater(WaterModel waterModel, String date) async {
    return await _firestoreDatabase.deleteWater(waterModel, date);
  }

  @override
  Stream<DocumentSnapshot<Object?>> getDayDoc(String date) {
    return _firestoreDatabase.getDayDoc(date);
  }
}