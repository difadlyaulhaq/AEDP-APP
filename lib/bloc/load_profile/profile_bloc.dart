import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'load_profile_event.dart';
import 'profile_state.dart';

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
      final userId = num.tryParse(event.id);
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
          roleData = await _fetchTeacherData(userId.toString()); // Konversi userId ke string
          fullName = roleData?['name']; // Ambil nama dari field 'name'
          break;
        case 'student':
          roleData = await _fetchStudentData(userId);
          fullName = roleData?['full_name']; // Ambil nama dari field 'full_name'
          break;
        case 'parent':
          roleData = await _fetchParentData(userId);
          fullName = roleData?['father_name']; // Ambil nama dari field 'father_name'
          break;
        default:
          throw Exception('Invalid role');
      }

      if (roleData == null || fullName == null) {
        throw Exception('Role-specific profile data not found');
      }

      final profileData = {
        'id': userId.toString(),
        'role': role,
        'fullName': fullName,
        'classes': roleData ['classes'], // Tambahkan classes ke dalam profileData
        ...roleData,
      };

      emit(LoadProfileLoaded(profileData: profileData));

    } catch (e) {
      emit(LoadProfileError(e.toString()));
    }
  }

 Future<Map<String, dynamic>?> _fetchTeacherData(String userId) async {
  final teacherDoc = await _firestore
      .collection('teachers')
      .where('contact', isEqualTo: userId) // Sesuai dengan kontak user
      .limit(1)
      .get();

  if (teacherDoc.docs.isNotEmpty) {
    final data = teacherDoc.docs.first.data();
    return {
      ...data,
      'classes': (data['classes'] as String).split(','), // Ubah dari string ke List<String>
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
    final parentDoc = await _firestore
        .collection('parents')
        .where('contact', isEqualTo: userId.toString())
        .limit(1)
        .get();

    if (parentDoc.docs.isNotEmpty) {
      final data = parentDoc.docs.first.data();
      return {
        ...data,
        'contact': data['contact'] ?? '',
        'whatsapp': data['whatsapp'] ?? '',
      };
    }
    return null;
  }
}
