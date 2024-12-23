import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  /// Save login status to shared preferences
  Future<void> saveLoginStatus(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInEmail', email);
    await prefs.setString('loggedInRole', role);
  }

  /// Load login status from shared preferences
  Future<Map<String, String>?> loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('loggedInEmail');
    final role = prefs.getString('loggedInRole');

    if (email != null && role != null) {
      return {'email': email, 'role': role};
    }
    return null;
  }

  /// Clear login status from shared preferences
  Future<void> clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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

      final hashedPassword = _hashPassword(password);

      await _firestore.collection('users').doc(email).set({
        'email': email,
        'role': role.toLowerCase(),
        'password': hashedPassword,
        'isVerified': false,
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
      final hashedPassword = _hashPassword(password);

      if (data?['password'] != hashedPassword) {
        throw Exception('Invalid password.');
      }

      await saveLoginStatus(email, data?['role']); // Save login status
      return data?['role'];
    } catch (e) {
      throw Exception('Failed to log in: ${e.toString()}');
    }
  }
}
