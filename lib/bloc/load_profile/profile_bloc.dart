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
      final collection = event.role == 'teacher' 
          ? 'teachers' 
          : event.role == 'student' 
              ? 'students' 
              : 'parents';
              
      final doc = await _firestore.collection(collection).doc(event.userId).get();

      if (!doc.exists) {
        throw Exception('Profile not found');
      }

      final profileData = doc.data() as Map<String, dynamic>;
      emit(LoadProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(LoadProfileError(e.toString()));
    }
  }
}