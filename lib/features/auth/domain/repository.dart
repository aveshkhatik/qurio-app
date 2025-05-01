// lib/services/repository.dart

import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCred.user!.updateDisplayName(name);
    await userCred.user!.sendEmailVerification();

    return userCred;
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() => _auth.signOut();
}