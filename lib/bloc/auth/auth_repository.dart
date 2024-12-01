import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;

  AuthRepository(this._firestore);

  /// Helper method: Fetch user document
  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserDoc(String email) async {
    return await _firestore.collection('users').doc(email).get();
  }

  /// Generate a hash for the password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// Sign up a user
  Future<void> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final userDoc = await _getUserDoc(email);

      if (userDoc.exists) {
        throw Exception('Email already registered.');
      }

      // Hash the password
      final hashedPassword = _hashPassword(password);

      // Save user data to Firestore
      await _firestore.collection('users').doc(email).set({
        'email': email,
        'role': role,
        'password': hashedPassword,  // Store the hashed password
        'isVerified': false,  // By default, set as not verified
        'createdAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  /// Login user
  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final userDoc = await _getUserDoc(email);

      if (!userDoc.exists) {
        throw Exception('User does not exist.');
      }

      final data = userDoc.data();

      // Check if password matches the stored hash
      final hashedPassword = _hashPassword(password);

      if (data?['password'] != hashedPassword) {
        throw Exception('Invalid password.');
      }

      // Return role if password matches
      return data?['role'];
    } catch (e) {
      throw Exception('Failed to log in: ${e.toString()}');
    }
  }
}
