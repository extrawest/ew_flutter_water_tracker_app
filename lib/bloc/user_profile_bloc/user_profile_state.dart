import 'package:equatable/equatable.dart';
import 'package:water_tracker/models/user_model.dart';

enum UserProfileStatus { loading, success, failure, updating }

class UserProfileState extends Equatable {
  final UserModel? user;
  final bool isEdit;
  final UserProfileStatus status;

  const UserProfileState(
      {this.user,
      this.status = UserProfileStatus.loading,
      this.isEdit = false});

  UserProfileState copyWith(
      {UserModel? user, UserProfileStatus? status, bool? isEdit}) {
    return UserProfileState(
        user: user ?? this.user,
        status: status ?? this.status,
        isEdit: isEdit ?? this.isEdit);
  }

  @override
  List<Object?> get props => [user, status, isEdit];
}
