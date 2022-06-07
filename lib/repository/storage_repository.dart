import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:water_tracker/services/firebase/analytics_service.dart';
import 'package:water_tracker/services/firebase/storage_service.dart';

abstract class StorageRepository {
  Future<void> uploadFile(XFile pickedFile);

  Future<String> getPhotoUrl();
}

class StorageRepositoryImpl implements StorageRepository {
  final StorageService storageService;
  final AnalyticsService analyticsService;

  StorageRepositoryImpl(
      {required this.storageService, required this.analyticsService});

  @override
  Future<String> getPhotoUrl() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return await storageService.getPhotoUrl(uid);
  }

  @override
  Future<void> uploadFile(XFile pickedFile) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final path = '$uid/profilePhoto';
    final file = File(pickedFile.path);

    await storageService.uploadFile(path, file);
    await analyticsService.photoUpdatedEvent();
  }
}
