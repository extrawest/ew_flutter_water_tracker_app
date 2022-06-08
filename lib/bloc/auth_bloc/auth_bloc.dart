import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_event.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc_state.dart';
import 'package:water_tracker/models/user_model.dart';
import 'package:water_tracker/services/firebase/crashlytics_service.dart';
import 'package:water_tracker/services/firebase/firebase_authentication.dart';

import '../../repository/firestore_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final FirestoreRepository firestoreRepository;
  final CrashlyticsService crashlyticsService;

  AuthBloc({required this.authService, required this.firestoreRepository, required this.crashlyticsService})
      : super(const AuthState()) {
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthRegister>(_onAuthRegister);
    on<AuthSignInGoogle>(_onAuthSignInGoogle);
    on<AuthSignInFacebook>(_onAuthSignInFacebook);
    on<AuthLogOut>(_onAuthLogOut);
  }

  Future<void> _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      await authService.signInWithEmailAndPassword(event.email, event.password);
      await firestoreRepository.setFcmToken();
      return emit(state.copyWith(status: AuthStatus.signedIn));
    } catch (err, trace) {
      crashlyticsService.recError(err.toString(), trace, reason: 'Email sign In error for ${event.email}');
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
          name: event.name,
          dailyWaterLimit: 3000,
          id: authService.firebaseAuth.currentUser!.uid);
      _addUserToFirestore(user);
      await firestoreRepository.setFcmToken();
      return emit(state.copyWith(status: AuthStatus.signedIn));
    } catch (err, trace) {
      crashlyticsService.recError(err.toString(), trace, reason: 'Register error for ${event.email}');
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onAuthSignInGoogle(
      AuthSignInGoogle event, Emitter<AuthState> emit) async {
    try {
      await authService.signInWithGoogle();
      final user = UserModel(
          email: authService.firebaseAuth.currentUser!.email!,
          name: '',
          dailyWaterLimit: 3000,
          id: authService.firebaseAuth.currentUser!.uid);
      _addUserToFirestore(user);

      await firestoreRepository.setFcmToken();
      return emit(state.copyWith(status: AuthStatus.signedIn));
    } catch (err, trace) {
      crashlyticsService.recError(err.toString(), trace, reason: 'Google sign In error');
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onAuthSignInFacebook(
      AuthSignInFacebook event, Emitter<AuthState> emit) async {
    try {
      await authService.signInWithFacebook();
      final user = UserModel(
          email: authService.firebaseAuth.currentUser!.email!,
          name: '',
          dailyWaterLimit: 3000,
          id: authService.firebaseAuth.currentUser!.uid);
      await firestoreRepository.setFcmToken();
      _addUserToFirestore(user);

      return emit(state.copyWith(status: AuthStatus.signedIn));
    } catch (err, trace) {
      crashlyticsService.recError(err.toString(), trace, reason: 'Facebook sign In error');
      emit(state.copyWith(status: AuthStatus.failure, error: err.toString()));
    }
  }

  Future<void> _onAuthLogOut(AuthLogOut event, Emitter<AuthState> emit) async {
    try {
      await authService.logOut();
      await firestoreRepository.setFcmToken();
      return emit(state.copyWith(status: AuthStatus.signedOut));
    } catch (err, trace) {
      crashlyticsService.recError(err.toString(), trace, reason: 'Log Out error');
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> _addUserToFirestore(UserModel model) async {
    await firestoreRepository.addUser(model);
  }
}
