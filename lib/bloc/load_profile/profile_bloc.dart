import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'load_profile_event.dart';
import 'profile_state.dart';
import 'dart:developer' as dev;

class LoadProfileBloc extends Bloc<LoadProfileEvent, LoadProfileState> {
  final FirebaseFirestore _firestore;

  LoadProfileBloc(this._firestore) : super(LoadProfileInitial()) {
    on<LoadUserProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadUserProfile event,
    Emitter<LoadProfileState> emit,
  ) async {
    emit(LoadProfileLoading());
    try {
      // Ambil data user berdasarkan ID
      final userId = num.tryParse(event.id)?.toInt();
      if (userId == null) throw Exception('Invalid user ID');

      final userDoc = await _firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        throw Exception('User not found');
      }

      final userData = userDoc.docs.first.data();
      final role = userData['role'] as String;

      // Ambil data berdasarkan role
      Map<String, dynamic>? roleData;
      String? fullName;
      switch (role.toLowerCase()) {
        case 'teacher':
          roleData = await _fetchTeacherData(userId.toString());
          fullName = roleData?['name'];
          break;
        case 'student':
          roleData = await _fetchStudentData(userId);
          fullName = roleData?['full_name'];
          break;
        case 'parent':
          roleData = await _fetchParentData(userId);
          fullName = roleData?['father_name'];
          break;
        default:
          throw Exception('Invalid role');
      }
      
      if (roleData == null) {
        dev.log('Role data not found for role: $role with userId: $userId');
        throw Exception('Role-specific profile data not found');
      }

      if (fullName == null) {
        dev.log('Full name is missing for role: $role with userId: $userId');
        throw Exception('Role-specific profile data not found');
      }

      final profileData = {
        'id': userId.toString(),
        'role': role,
        'fullName': fullName,
        'classes': roleData['classes'] is String
            ? (roleData['classes'] as String).split(',').map((e) => e.trim()).toList()
            : (roleData['classes'] as List<dynamic>?)?.cast<String>() ?? [],
        ...roleData,
      };

      emit(LoadProfileLoaded(profileData: profileData));

    } catch (e) {
      dev.log('Error loading profile: $e');
      emit(LoadProfileError(e.toString()));
    }
  }

  Future<Map<String, dynamic>?> _fetchTeacherData(String userId) async {
    final teacherDoc = await _firestore
        .collection('teachers')
        .where('contact', isEqualTo: userId)
        .limit(1)
        .get();

    if (teacherDoc.docs.isNotEmpty) {
      final data = teacherDoc.docs.first.data();
      
      // Handle the 'classes' field
      final classes = data['classes'];
      List<String> classesList = [];
      
      if (classes is String) {
        classesList = classes.split(',').map((e) => e.trim()).toList();
      } else if (classes is List<dynamic>) {
        classesList = classes.cast<String>();
      }

      return {
        ...data,
        'classes': classesList,
        'contact': data['contact'] ?? '',
        'whatsapp': data['whatsapp'] ?? '',
      };
    }
    return null;
  }

  Future<Map<String, dynamic>?> _fetchStudentData(num userId) async {
    final studentDoc = await _firestore
        .collection('students')
        .where('school_id', isEqualTo: userId.toString())
        .limit(1)
        .get();

    if (studentDoc.docs.isNotEmpty) {
      final data = studentDoc.docs.first.data();
      return {
        ...data,
        'school_id': data['school_id'] ?? '',
        'profile_picture': data['profile_picture'] ?? '',
      };
    }
    return null;
  }

  Future<Map<String, dynamic>?> _fetchParentData(num userId) async {
    dev.log('Fetching parent data for userId: $userId');
    
    // First, try to find by exact contact match
    var parentDoc = await _firestore
        .collection('parents')
        .where('contact', isEqualTo: userId.toString())
        .limit(1)
        .get();

    // If not found, try with zero-padded format (000004 for userId 4)
    if (parentDoc.docs.isEmpty) {
      String paddedUserId = userId.toString().padLeft(6, '0');
      dev.log('Trying with padded userId: $paddedUserId');
      
      parentDoc = await _firestore
          .collection('parents')
          .where('contact', isEqualTo: paddedUserId)
          .limit(1)
          .get();
    }

    if (parentDoc.docs.isNotEmpty) {
      final data = parentDoc.docs.first.data();
      dev.log('Found parent data: ${data.keys}');
      return {
        ...data,
        'contact': data['contact'] ?? '',
        'whatsapp': data['whatsapp'] ?? '',
        'mother_name': data['mother_name'] ?? 'N/A',
        'father_name': data['father_name'] ?? 'N/A',
        'student_name': data['student_name'] ?? 'N/A',
        'address': data['address'] ?? 'N/A',
      };
    }
    
    dev.log('Parent data not found for userId: $userId');
    return null;
  }
}