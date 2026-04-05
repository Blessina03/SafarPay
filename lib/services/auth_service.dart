import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 SIGNUP
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print("Auth error: $e");
      rethrow;
    }
  }

  // 🔹 LOGIN
  Future<User?> login(String email, String password) async {
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Login error: ${e.message}");
      return null;
    }
  }
}