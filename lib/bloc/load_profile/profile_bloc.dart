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
      final QuerySnapshot snapshot = await _firestore.collection('users')
          .where('email', isEqualTo: event.email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('Profile not found for email: ${event.email}');
      }

      final profileData = snapshot.docs.first.data() as Map<String, dynamic>;
      emit(LoadProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(LoadProfileError(e.toString()));
    }
  }
}
