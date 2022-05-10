import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/logger.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      return user;
    } on FirebaseException catch (err) {
      log.severe('$err');
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = result.user;
      return user;
    } on FirebaseException catch (err) {
      log.severe('$err');
      return null;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get currentUser {
    return _firebaseAuth.authStateChanges().map((User? user) {
      if(user != null) {
        return user;
      } else {
        return null;
      }
    });
  }
}
