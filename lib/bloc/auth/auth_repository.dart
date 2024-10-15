import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

  // Sign up method with role assignment
  Future<void> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user role to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'role': role,
      });
    } catch (e) {
      throw Exception('Error creating account: $e');
    }
  }

  // Login method that checks role
  Future<String?> logIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch the user's role from Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user?.uid).get();
      return userDoc['role'];
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }
}
