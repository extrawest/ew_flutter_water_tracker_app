import 'package:equatable/equatable.dart';
import 'package:water_tracker/models/user_model.dart';

enum AuthStatus { signedOut, signedIn, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String error;
  final UserModel? user;

  const AuthState(
      {this.status = AuthStatus.signedOut, this.error = '', this.user});

  AuthState copyWith({AuthStatus? status, String? error, UserModel? user}) {
    return AuthState(
        status: status ?? this.status,
        error: error ?? this.error,
        user: user ?? this.user);
  }

  @override
  List<Object?> get props => [status, error, user];
}
