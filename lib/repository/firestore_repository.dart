import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/services/firebase/firestore.dart';

abstract class FirestoreRepository {
  Future<void> addUser(UserModel model);

  Future<void> addWater(WaterModel waterModel, String date);

  Future<UserModel> getUser(String id);
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
}