import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {}

class LoadUserPhoto extends UserProfileEvent {}

class CheckEdit extends UserProfileEvent {
  final bool check;

  CheckEdit(this.check);
}

class SaveChanges extends UserProfileEvent {
  final String name;
  final String dailyWaterLimit;

  SaveChanges(this.name, this.dailyWaterLimit);
}

class PickPhotoFromGallery extends UserProfileEvent {}