import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_event.dart';
import 'package:water_tracker/bloc/user_profile_bloc/user_profile_state.dart';
import 'package:water_tracker/repository/firestore_repository.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final FirestoreRepository repository;

  UserProfileBloc(this.repository) : super(const UserProfileState()) {
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    final user = await repository.getUser();
    return emit(state.copyWith(user: user, status: UserProfileStatus.success));
  }
}
