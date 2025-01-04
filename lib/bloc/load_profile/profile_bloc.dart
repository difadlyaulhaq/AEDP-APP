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
      // Convert string ID to num
      final num userId = num.parse(event.id);
      
      // First get the user document
      final userDoc = await _firestore.collection('users')
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();
      
      if (userDoc.docs.isEmpty) {
        throw Exception('User not found');
      }

      final userData = userDoc.docs.first.data();
      final role = userData['role'] as String;

      // Get role-specific data
      Map<String, dynamic>? roleData;
      switch (role.toLowerCase()) {
        case 'teacher':
          final teacherDoc = await _firestore.collection('teachers')
              .where('id', isEqualTo: userId)
              .limit(1)
              .get();
          if (teacherDoc.docs.isNotEmpty) {
            roleData = teacherDoc.docs.first.data();
            roleData = {
              ...roleData,
              'classes': List<String>.from(roleData['classes'] ?? []),
              'contact': roleData['contact']?.toString() ?? '',
              'whatsapp': roleData['whatsapp'] ?? '',
            };
          }
          break;

        case 'student':
          final studentDoc = await _firestore.collection('students')
              .where('id', isEqualTo: userId)
              .limit(1)
              .get();
          if (studentDoc.docs.isNotEmpty) {
            roleData = studentDoc.docs.first.data();
            roleData = {
              ...roleData,
              'school_id': roleData['school_id'] ?? '',
              'profile_picture': roleData['profile_picture'] ?? '',
            };
          }
          break;

        case 'parent':
          final parentDoc = await _firestore.collection('parents')
              .where('id', isEqualTo: userId)
              .limit(1)
              .get();
          if (parentDoc.docs.isNotEmpty) {
            roleData = parentDoc.docs.first.data();
            roleData = {
              ...roleData,
              'contact': roleData['contact'] ?? '',
              'whatsapp': roleData['whatsapp'] ?? '',
            };
          }
          break;

        default:
          throw Exception('Invalid role');
      }

      if (roleData == null) {
        throw Exception('Profile data not found');
      }

      // Combine user data with role-specific data
      final profileData = {
        'id': userId.toString(),
        'role': role,
        ...roleData,
      };

      emit(LoadProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(LoadProfileError(e.toString()));
    }
  }
}

