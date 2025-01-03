import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;

  AuthRepository(this._firestore);

  Future<void> saveLoginStatus(num userId, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loggedInUserId', userId.toInt());
    await prefs.setString('loggedInRole', role);
  }

  Future<Map<String, dynamic>?> loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('loggedInUserId');
    final role = prefs.getString('loggedInRole');

    if (userId != null && role != null) {
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
      final userQuery = await _firestore
          .collection('users')
          .where('id', isEqualTo: id)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data();
        return {
          'userId': userData['id'],
          'role': userData['role'],
        };
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}