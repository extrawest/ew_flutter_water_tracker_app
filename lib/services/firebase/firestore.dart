import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/models/water_model.dart';

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

class FirestoreDatabase {
  Future<void> addUser(UserModel model) async {
    /// We need to check if user has already existed in firestore
    /// in cases when we use Google or Facebook Authentication
    if ((await usersCollection.doc(model.id).get()).exists) {
      return;
    }
    await usersCollection.doc(model.id).set(model.toJson());
  }

  Future<UserModel> getUser(String id) async {
    final DocumentSnapshot documentSnapshot =
        await usersCollection.doc(id).get();
    return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<void> addWater(WaterModel waterModel, String date) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference _daysCollection =
        usersCollection.doc(uid).collection('days');

    await _daysCollection.doc(date).set({
      'water': FieldValue.arrayUnion([waterModel.toJson()])
    }, SetOptions(merge: true));
  }

  Future<void> deleteWater(WaterModel waterModel, String date) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final CollectionReference _daysCollection =
        usersCollection.doc(uid).collection('days');

    await _daysCollection.doc(date).update({
      'water': FieldValue.arrayRemove([waterModel.toJson()])
    });
  }

  Stream<DocumentSnapshot<List<WaterModel>>> getDayDoc(String date) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final dayDocRef = usersCollection.doc(uid).collection('days').doc(date);

    return dayDocRef.withConverter<List<WaterModel>>(fromFirestore: (snapshot, _) {
      return List<WaterModel>.from(snapshot['water'].map((e) {
        return WaterModel.fromJson(e);
      }));
    }, toFirestore: (model, _) {
      return {};
    }).snapshots();
  }
}
