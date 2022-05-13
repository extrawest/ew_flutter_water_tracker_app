import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_event.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_state.dart';
import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/services/firebase/firebase_authentication.dart';

import '../../repository/firestore_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final FirestoreRepository firestoreRepository;

  AuthBloc({required this.authService, required this.firestoreRepository})
      : super(const AuthState()) {
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthRegister>(_onAuthRegister);
    on<AuthSignInGoogle>(_onAuthSignInGoogle);
    on<AuthSignInFacebook>(_onAuthSignInFacebook);
    on<AuthLogOut>(_onAuthLogOut);
  }

  Future<void> _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    try {
      await authService.signInWithEmailAndPassword(event.email, event.password);
      final user = UserModel(
          email: authService.firebaseAuth.currentUser!.email!,
          dailyWaterLimit: 3000,
          id: authService.firebaseAuth.currentUser!.uid);

      return emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onAuthRegister(
      AuthRegister event, Emitter<AuthState> emit) async {
    try {
      await authService.registerWithEmailAndPassword(
          event.email, event.password);
      final user = UserModel(
          email: authService.firebaseAuth.currentUser!.email!,
          dailyWaterLimit: 3000,
          id: authService.firebaseAuth.currentUser!.uid);
      _addUserToFirestore(user);

      return emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onAuthSignInGoogle(
      AuthSignInGoogle event, Emitter<AuthState> emit) async {
    try {
      await authService.signInWithGoogle();
      final user = UserModel(
          email: authService.firebaseAuth.currentUser!.email!,
          dailyWaterLimit: 3000,
          id: authService.firebaseAuth.currentUser!.uid);
      _addUserToFirestore(user);

      return emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onAuthSignInFacebook(
      AuthSignInFacebook event, Emitter<AuthState> emit) async {
    try {
      await authService.signInWithFacebook();
      final user = UserModel(
          email: authService.firebaseAuth.currentUser!.email!,
          dailyWaterLimit: 3000,
          id: authService.firebaseAuth.currentUser!.uid);
      _addUserToFirestore(user);

      return emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    } catch (err) {
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onAuthLogOut(AuthLogOut event, Emitter<AuthState> emit) async {
    try {
      await authService.logOut();
      return emit(state.copyWith(user: null, status: AuthStatus.signedOut));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _addUserToFirestore(UserModel model) async {
    await firestoreRepository.addUser(model);
  }
}
