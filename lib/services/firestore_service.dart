import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> saveUser(String name, String email) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
        'name': name,
        'email': email,
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}