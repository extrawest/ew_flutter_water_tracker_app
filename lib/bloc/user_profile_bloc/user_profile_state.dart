import 'package:equatable/equatable.dart';
import 'package:water_tracker/models/user_model.dart';

enum UserProfileStatus { loading, success, failure, updating }

class UserProfileState extends Equatable {
  final UserModel? user;
  final bool isEdit;
  final UserProfileStatus status;
  final String photoUrl;

  const UserProfileState(
      {this.user,
      this.status = UserProfileStatus.loading,
      this.isEdit = false, this.photoUrl = ''});

  UserProfileState copyWith(
      {UserModel? user, UserProfileStatus? status, bool? isEdit, String? photoUrl}) {
    return UserProfileState(
        user: user ?? this.user,
        status: status ?? this.status,
        isEdit: isEdit ?? this.isEdit, photoUrl: photoUrl ?? this.photoUrl);
  }

  @override
  List<Object?> get props => [user, status, isEdit, photoUrl];
}
