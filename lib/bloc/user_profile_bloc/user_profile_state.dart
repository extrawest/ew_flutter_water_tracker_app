import 'package:equatable/equatable.dart';
import 'package:water_tracker/models/user_model.dart';

enum UserProfileStatus { initial, loading, success, failure }

class UserProfileState extends Equatable {
  final UserModel? user;
  final UserProfileStatus status;

  const UserProfileState({this.user, this.status = UserProfileStatus.initial});

  UserProfileState copyWith({UserModel? user, UserProfileStatus? status}) {
    return UserProfileState(user: user ?? this.user, status: status ?? this.status);
  }

  @override
  List<Object?> get props => [user, status];
}
