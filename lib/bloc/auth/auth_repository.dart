// AuthRepository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;
import 'package:bcrypt/bcrypt.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;

  AuthRepository(this._firestore);

  Future<void> saveLoginStatus(num userId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUserId', userId.toString());
    await prefs.setString('loggedInRole', role);
  }

  Future<Map<String, dynamic>?> loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdStr = prefs.getString('loggedInUserId');
    final role = prefs.getString('loggedInRole');

    if (userIdStr != null && role != null) {
      return {
        'userId': num.parse(userIdStr),  // Convert back to num
        'role': role,
      };
    }
    return null;
  }

  Future<void> clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

 Future<Map<String, dynamic>?> logIn({
  required num id,
  required String password,
}) async {
  try {
    dev.log('Attempting login with ID: $id');

    final userQuery = await _firestore
        .collection('users')
        .where('id', isEqualTo: id) // Pastikan ini konsisten dengan tipe data di Firestore
        .get();

    dev.log('Query results: ${userQuery.docs.length}');

    if (userQuery.docs.isNotEmpty) {
      final userData = userQuery.docs.first.data();
      final storedPassword = userData['password'] as String;

      // Validasi password dengan hash
      final isPasswordValid = BCrypt.checkpw(password, storedPassword);
      if (isPasswordValid) {
        dev.log('Password valid for user ID: $id');
        return {
          'userId': userData['id'], // Ambil ID dari Firestore
          'role': userData['role'], // Ambil role dari Firestore
        };
      } else {
        dev.log('Invalid password for user ID: $id');
        return null;
      }
    }

    dev.log('No matching user found for ID: $id');
    return null;
  } catch (e) {
    dev.log('Login error: $e');
    throw Exception('Login failed: $e');
  }
}
}
