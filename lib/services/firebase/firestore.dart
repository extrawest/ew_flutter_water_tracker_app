import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/models/water_model.dart';
import 'package:water_tracker/services/firebase/analytics_service.dart';

class FirestoreDatabase {
  final AnalyticsService analyticsService;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  FirestoreDatabase(this.analyticsService);

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
      return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUsername(String name) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try{
      await usersCollection
        .doc(uid)
        .update({'name': name});
      await analyticsService.nameUpdatedEvent(name);
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
      analyticsService.addWaterEvent(waterModel.amount);
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

      return dayDocRef.withConverter<List<WaterModel>>(
          fromFirestore: (snapshot, _) {
            return List<WaterModel>.from(snapshot['water'].map((e) {
              return WaterModel.fromJson(e);
            }));
          }, toFirestore: (model, _) {
        return {};
      }).snapshots();
    } catch (e) {
      rethrow;
    }
  }
}
