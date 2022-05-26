import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'analytics_service.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final AnalyticsService analyticsService;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  StorageService(this.analyticsService);

  Future<void> uploadFile(XFile pickedFile) async {
    final path = '$uid/profilePhoto';
    final file = File(pickedFile.path);

    final ref = _firebaseStorage.ref().child(path);
    await ref.delete();
    await ref.putFile(file);
    await analyticsService.photoUpdatedEvent();
  }

  Future<String> getPhotoUrl() async {
    try {
      final ref = _firebaseStorage.ref().child('$uid/profilePhoto');
      return await ref.getDownloadURL();
    } on FirebaseException {
      rethrow;
    }
  }
}
