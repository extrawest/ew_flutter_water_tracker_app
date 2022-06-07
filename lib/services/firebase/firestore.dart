import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/models/water_model.dart';

class FirestoreDatabase {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel model) async {
    /// We need to check if user has already existed in firestore
    /// in cases when we use Google or Facebook Authentication
    if ((await usersCollection.doc(model.id).get()).exists) {
      return;
    }
    await usersCollection.doc(model.id).set(model.toJson());
  }

  Future<UserModel> getUser() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final DocumentSnapshot documentSnapshot =
          await usersCollection.doc(uid).get();
      return UserModel.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUsername(String name) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await usersCollection.doc(uid).update({'name': name});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setUserToken(String token) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try{
      await usersCollection.doc(uid).update({'fcmToken': token});
    } catch(e) {
      rethrow;
    }
  }

  Future<int> getDailyLimit() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final userDoc = await usersCollection.doc(uid).get();
      final user = userDoc.data() as Map<String, dynamic>;
      return user['daily_water_limit'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDailyLimit(int dailyWaterLimit) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await usersCollection
          .doc(uid)
          .update({'daily_water_limit': dailyWaterLimit});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addWater(WaterModel waterModel, String date) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final CollectionReference _daysCollection =
          usersCollection.doc(uid).collection('days');

      await _daysCollection.doc(date).set({
        'water': FieldValue.arrayUnion([waterModel.toJson()])
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWater(WaterModel waterModel, String date) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final CollectionReference _daysCollection =
          usersCollection.doc(uid).collection('days');

      await _daysCollection.doc(date).update({
        'water': FieldValue.arrayRemove([waterModel.toJson()])
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot<List<WaterModel>>> getDayDoc(String date) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final dayDocRef = usersCollection.doc(uid).collection('days').doc(date);

      return dayDocRef
          .withConverter<List<WaterModel>>(
              fromFirestore: (snapshot, _) {
                return List<WaterModel>.from(
                    snapshot['water'].map((e) => WaterModel.fromJson(e)));
              },
              toFirestore: (model, _) => {})
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }
}
