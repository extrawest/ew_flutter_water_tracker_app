import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_event.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_state.dart';
import 'package:water_tracker/repository/firestore_repository.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final FirestoreRepository repository;

  UserProfileBloc(this.repository) : super(const UserProfileState()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<CheckEdit>(_onCheckEdit);
    on<SaveChanges>(_onSaveChanges);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    final user = await repository.getUser();
    return emit(state.copyWith(user: user, status: UserProfileStatus.success));
  }

  Future<void> _onSaveChanges(
      SaveChanges event, Emitter<UserProfileState> emit) async {
    if (event.name == state.user!.name &&
        int.parse(event.dailyWaterLimit) == state.user!.dailyWaterLimit) {
      return emit(state.copyWith(isEdit: false));
    }
    emit(state.copyWith(status: UserProfileStatus.updating));
    if (event.name != state.user!.name) {
      await repository.updateUsername(event.name);
    }
    final int limit = int.parse(event.dailyWaterLimit);
    if (limit != state.user!.dailyWaterLimit) {
      await repository.updateDailyLimit(limit);
    }

    final user = await repository.getUser();
    return emit(state.copyWith(
        user: user, status: UserProfileStatus.success, isEdit: false));
  }

  void _onCheckEdit(CheckEdit event, Emitter<UserProfileState> emit) {
    if (state.status == UserProfileStatus.success) {
      return emit(state.copyWith(isEdit: event.check));
    }
  }
}
