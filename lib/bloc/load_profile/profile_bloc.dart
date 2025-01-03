import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'load_profile_event.dart';
import 'profile_state.dart';

class LoadProfileBloc extends Bloc<LoadProfileEvent, LoadProfileState> {
  final FirebaseFirestore _firestore;

  LoadProfileBloc(this._firestore) : super(LoadProfileInitial()) {
    on<LoadUserProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(LoadUserProfile event, Emitter<LoadProfileState> emit) async {
    emit(LoadProfileLoading());
    try {
      // First get the user document
      final userSnapshot = await _firestore.collection('users')
          .where('id', isEqualTo: event.id)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        throw Exception('Profile not found for ID: ${event.id}');
      }

      final userData = userSnapshot.docs.first.data();
      final role = userData['role'] as String;
      
      // Get role-specific data based on user role
      Map<String, dynamic> roleData = {};
      
      switch (role) {
        case 'teacher':
          final teacherDoc = await _firestore.collection('teachers')
              .where('id', isEqualTo: event.id)
              .limit(1)
              .get();
          if (teacherDoc.docs.isNotEmpty) {
            roleData = teacherDoc.docs.first.data();
          }
          break;
          
        case 'student':
          final studentDoc = await _firestore.collection('students')
              .where('id', isEqualTo: event.id)
              .limit(1)
              .get();
          if (studentDoc.docs.isNotEmpty) {
            roleData = studentDoc.docs.first.data();
          }
          break;
          
        case 'parent':
          final parentDoc = await _firestore.collection('parents')
              .where('id', isEqualTo: event.id)
              .limit(1)
              .get();
          if (parentDoc.docs.isNotEmpty) {
            roleData = parentDoc.docs.first.data();
          }
          break;
      }

      // Combine user data with role-specific data
      final completeProfileData = {
        ...userData,
        ...roleData,
      };

      emit(LoadProfileLoaded(profileData: completeProfileData));
    } catch (e) {
      emit(LoadProfileError(e.toString()));
    }
  }
}