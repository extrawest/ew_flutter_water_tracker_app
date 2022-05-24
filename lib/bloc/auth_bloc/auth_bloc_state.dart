import 'package:equatable/equatable.dart';

enum AuthStatus { signedOut, signedIn, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String error;
  //final UserModel? user;

  const AuthState(
      {this.status = AuthStatus.signedOut, this.error = ''});

  AuthState copyWith({AuthStatus? status, String? error}) {
    return AuthState(
        status: status ?? this.status,
        error: error ?? this.error,
        );
  }

  @override
  List<Object?> get props => [status, error];
}
