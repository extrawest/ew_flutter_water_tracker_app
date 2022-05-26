import 'package:image_picker/image_picker.dart';
import 'package:water_tracker/services/firebase/storage_service.dart';

abstract class StorageRepository {
  Future<void> uploadFile(XFile pickedFile);

  Future<String> getPhotoUrl();
}

class StorageRepositoryImpl implements StorageRepository {
  final StorageService _storageService;

  StorageRepositoryImpl(this._storageService);

  @override
  Future<String> getPhotoUrl() async {
    return await _storageService.getPhotoUrl();
  }

  @override
  Future<void> uploadFile(XFile pickedFile) async {
    await _storageService.uploadFile(pickedFile);
  }
}