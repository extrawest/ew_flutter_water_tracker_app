import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_event.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_state.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/repository/storage_repository.dart';
import 'package:water_tracker/services/firebase/crashlytics_service.dart';
import 'package:water_tracker/services/firebase/dynamic_links_service.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final FirestoreRepository firestoreRepository;
  final StorageRepository storageRepository;
  final CrashlyticsService crashlyticsService;
  final DynamicLinksService dynamicLinksService = DynamicLinksService();
  final imagePicker = ImagePicker();

  UserProfileBloc({required this.firestoreRepository,
    required this.storageRepository,
    required this.crashlyticsService})
      : super(const UserProfileState()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LoadUserPhoto>(_onLoadUserPhoto);
    on<PickPhotoFromGallery>(_onPickPhotoFromGallery);
    on<CheckEdit>(_onCheckEdit);
    on<SaveChanges>(_onSaveChanges);
  }

  Future<void> _onLoadUserProfile(LoadUserProfile event,
      Emitter<UserProfileState> emit) async {
    try {
      emit(state.copyWith(status: UserProfileStatus.initial));
      final user = await firestoreRepository.getUser();
      return emit(state.copyWith(
          user: user, photoUrl: '', status: UserProfileStatus.success));
    } catch (e, trace) {
      crashlyticsService.recError(e.toString(), trace,
          reason: 'Failed to load user profile from firestore');
      emit(state.copyWith(status: UserProfileStatus.failure));
    }
  }

  Future<void> _onLoadUserPhoto(LoadUserPhoto event,
      Emitter<UserProfileState> emit) async {
    try {
      final photoUrl = await storageRepository.getPhotoUrl();
      return emit(state.copyWith(photoUrl: photoUrl));
    } catch (e, trace) {
      crashlyticsService.recError(e.toString(), trace,
          reason: 'Failed to load user photo from storage');
      return emit(state.copyWith(photoUrl: ''));
    }
  }

  Future<void> _onSaveChanges(SaveChanges event,
      Emitter<UserProfileState> emit) async {
    try {
      final user = state.user!;
      final int limit = int.parse(event.dailyWaterLimit);

      if (event.name == user.name && limit == user.dailyWaterLimit) {
        return emit(state.copyWith(isEdit: false));
      }
      emit(state.copyWith(status: UserProfileStatus.updating));
      if (event.name != user.name) {
        await firestoreRepository.updateUsername(event.name);
      }
      if (limit != user.dailyWaterLimit) {
        await firestoreRepository.updateDailyLimit(limit);
        emit(state.copyWith(status: UserProfileStatus.updatedDailyLimit));
      }

      final newUser = await firestoreRepository.getUser();
      return emit(state.copyWith(
          user: newUser, status: UserProfileStatus.success, isEdit: false));
    } catch (e, trace) {
      crashlyticsService.recError(e.toString(), trace,
          reason: 'Failed to update user profile info with: Name: ${event
              .name}, Daily Water limit${event.dailyWaterLimit}');
      return emit(state.copyWith(status: UserProfileStatus.failure));
    }
  }

  void _onCheckEdit(CheckEdit event, Emitter<UserProfileState> emit) {
    if (state.status == UserProfileStatus.success) {
      return emit(state.copyWith(isEdit: event.check));
    }
  }

  Future<void> _onPickPhotoFromGallery(PickPhotoFromGallery event,
      Emitter<UserProfileState> emit) async {
    final XFile? image =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    await storageRepository.uploadFile(image);
    final photoUrl = await storageRepository.getPhotoUrl();
    return emit(state.copyWith(photoUrl: photoUrl));
  }
}
