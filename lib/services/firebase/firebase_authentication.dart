import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/logger.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  Stream<User?> get authState => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      final UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      return user;
    } on FirebaseException catch (err) {
      log.severe('$err');
      rethrow;
    }
  }

  Future<User?> registerWithEmailAndPassword(String email,
      String password) async {
    try {
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      return user;
    } on FirebaseException catch (err) {
      log.severe('$err');
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential = FacebookAuthProvider
        .credential(loginResult.accessToken!.token);

    return await _firebaseAuth.signInWithCredential(facebookAuthCredential);
  }

  Future<void> logOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await _firebaseAuth.signOut();
  }
}
