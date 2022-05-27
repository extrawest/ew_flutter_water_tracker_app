import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'analytics_service.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final AnalyticsService analyticsService;

  StorageService(this.analyticsService);

  Future<void> uploadFile(XFile pickedFile) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final path = '$uid/profilePhoto';
    final file = File(pickedFile.path);

    final ref = _firebaseStorage.ref().child(path);
    await ref.putFile(file);
    await analyticsService.photoUpdatedEvent();
  }

  Future<String> getPhotoUrl() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      final ref = _firebaseStorage.ref().child('$uid/profilePhoto');
      return await ref.getDownloadURL();
    } on FirebaseException {
      rethrow;
    }
  }
}
