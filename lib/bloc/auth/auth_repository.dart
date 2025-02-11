import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;
import 'package:bcrypt/bcrypt.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;

  AuthRepository(this._firestore);

  Future<void> saveLoginStatus(num userId, String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('role', role);
  await prefs.setString('userId', userId.toInt().toString()); // Simpan sebagai string
  dev.log('Login status saved: UserId: ${userId.toInt()}, Role: $role');
}

Future<Map<String, dynamic>?> loadLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final userIdString = prefs.getString('userId'); // Ambil sebagai string
  final role = prefs.getString('role');
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  dev.log('Retrieved login status - isLoggedIn: $isLoggedIn, Role: $role, UserId: $userIdString');
  
  if (isLoggedIn && userIdString != null && role != null) {
    final userId = int.tryParse(userIdString) ?? num.tryParse(userIdString);
    if (userId == null) {
      dev.log('Error parsing userId: $userIdString');
      return null;
    }
    return {
      'userId': userId,
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
          .where('id', isEqualTo: id)
          .get();

      dev.log('Query results: ${userQuery.docs.length}');

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data();
        final storedPassword = userData['password'] as String;

        final isPasswordValid = BCrypt.checkpw(password, storedPassword);
        if (isPasswordValid) {
          dev.log('Password valid for user ID: $id');
          return {
            'userId': userData['id'],
            'role': userData['role'],
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
