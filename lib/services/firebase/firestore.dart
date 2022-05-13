import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_tracker/models/user_model.dart';

class FirestoreDatabase {
  final _db = FirebaseFirestore.instance;
  DocumentReference? userDoc;

  Future<void> addUser(UserModel model) async {
    /// We need to check if user has already existed in firestore
    /// in cases when we use Google or Facebook Authentication
    if((await _db.collection('users').doc(model.id).get()).exists) {
      return;
    }
    await _db
        .collection('users')
        .doc(model.id)
        .set(model.toJson());
    userDoc = _db.collection('users').doc(model.id);
  }

  Future<UserModel> getUser(String id) async {
    userDoc = _db.collection('users').doc(id);

    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _db
        .collection('users')
        .doc(id).get();
    return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<void> addWater(DayModel dayModel) async {
    final CollectionReference _daysCollection = _db
        .collection('users')
        .doc(userDoc!.id)
        .collection('days');

    await _daysCollection.doc(dayModel.id)
        .set(dayModel.toJson());
  }
}
