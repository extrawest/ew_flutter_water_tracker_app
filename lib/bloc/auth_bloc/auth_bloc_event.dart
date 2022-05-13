import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn({required this.email, required this.password});
}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;

  AuthRegister({required this.email, required this.password});
}

class AuthSignInGoogle extends AuthEvent {}

class AuthSignInFacebook extends AuthEvent {}

class AuthLogOut extends AuthEvent {}
