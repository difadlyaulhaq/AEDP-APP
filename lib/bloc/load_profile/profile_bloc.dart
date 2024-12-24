import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'load_profile_event.dart';
import 'profile_state.dart';

class LoadProfileBloc extends Bloc<LoadProfileEvent, LoadProfileState> {
  LoadProfileBloc() : super(LoadProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfileEvent event, Emitter<LoadProfileState> emit) async {
    emit(LoadProfileLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(event.teacherId)
          .get();

      if (!doc.exists) {
        throw Exception('Profile not found.');
      }

      final profileData = doc.data() as Map<String, dynamic>;
      emit(LoadProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(LoadProfileError(e.toString()));
    }
  }
}
