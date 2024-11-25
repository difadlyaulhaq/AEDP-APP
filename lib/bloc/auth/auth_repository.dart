import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;

  AuthRepository(this._firestore);

  /// Helper method: Fetch user document
  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserDoc(String email) async {
    return await _firestore.collection('users').doc(email).get();
  }

  /// Generate OTP (6 digits)
  String _generateOTP() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  /// Hash OTP using SHA-256
  String _hashOTP(String otp) {
    final bytes = utf8.encode(otp);
    return sha256.convert(bytes).toString();
  }

  /// Sign up a user
  Future<void> signUp({
    required String email,
    required String role,
  }) async {
    try {
      final userDoc = await _getUserDoc(email);

      if (userDoc.exists) {
        throw Exception('Email already registered.');
      }

      // Generate and hash OTP
      final otp = _generateOTP();
      final hashedOTP = _hashOTP(otp);

      // Save user data to Firestore
      await _firestore.collection('users').doc(email).set({
        'email': email,
        'role': role,
        'otp': hashedOTP,
        'isVerified': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Mocked OTP sending (replace with real service)
      //print('OTP for $email: $otp');
    } catch (e) {
      throw Exception('Failed to sign up: ${e.toString()}');
    }
  }

  /// Verify OTP
  Future<void> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final userDoc = await _getUserDoc(email);

      if (!userDoc.exists) {
        throw Exception('User does not exist.');
      }

      final data = userDoc.data();
      final hashedOTP = _hashOTP(otp);

      if (data?['otp'] != hashedOTP) {
        throw Exception('Invalid OTP.');
      }

      // Update user as verified
      await _firestore.collection('users').doc(email).update({
        'isVerified': true,
        'otp': null, // Clear OTP after verification
      });
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Login user
  Future<String?> logIn({
    required String email,
  }) async {
    try {
      final userDoc = await _getUserDoc(email);

      if (!userDoc.exists) {
        throw Exception('User does not exist.');
      }

      final data = userDoc.data();

      if (data?['isVerified'] != true) {
        throw Exception('Email is not verified.');
      }

      return data?['role'];
    } catch (e) {
      throw Exception('Failed to log in: ${e.toString()}');
    }
  }
}
