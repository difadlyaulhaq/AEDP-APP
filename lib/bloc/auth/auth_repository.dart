import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

  /// Sign up method with role assignment
  Future<void> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Ensure role is valid
      const validRoles = ['admin', 'user', 'guest'];
      if (!validRoles.contains(role)) {
        throw Exception('Invalid role. Accepted roles are: $validRoles');
      }

      // Create user with Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user details and role in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'role': role,
      });
    } catch (e) {
      throw Exception('Failed to create account: ${e.toString()}');
    }
  }

  /// Login method with role verification
  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      // Authenticate user with Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user role from Firestore
      final userId = userCredential.user?.uid;
      if (userId == null) {
        throw Exception('User ID is null');
      }

      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final role = userDoc.data()?['role'];
        if (role == null) {
          throw Exception('Role is not assigned for this user.');
        }
        return role;
      } else {
        throw Exception('No user data found in Firestore.');
      }
    } catch (e) {
      throw Exception('Failed to log in: ${e.toString()}');
    }
  }
}
