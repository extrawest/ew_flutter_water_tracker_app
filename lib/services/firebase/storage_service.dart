import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';


class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadFile(String path, File file) async {
    try{
      final ref = _firebaseStorage.ref().child(path);
      await ref.putFile(file);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<String> getPhotoUrl(String uid) async {
    try {
      final ref = _firebaseStorage.ref().child('$uid/profilePhoto');
      return await ref.getDownloadURL();
    } on FirebaseException {
      rethrow;
    }
  }
}
