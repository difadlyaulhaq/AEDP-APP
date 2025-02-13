import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final FirebaseFirestore firestore;

  ScheduleBloc({required this.firestore}) : super(ScheduleInitial()) {
    on<FetchSchedule>(_onFetchSchedule);
  }

  Future<void> _onFetchSchedule(
    FetchSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      final userId = num.tryParse(event.userId);
      if (userId == null) {
        emit(ScheduleError("Invalid user ID"));
        return;
      }

      final userDoc = await firestore
          .collection('users')
          .where('id', isEqualTo: userId)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        emit(ScheduleError("User not found"));
        return;
      }

      final userData = userDoc.docs.first.data();
      final role = userData['role'] as String?;

      Query<Map<String, dynamic>> scheduleQuery = firestore.collection('schedules');
      if (role?.toLowerCase() == 'student') {
        final studentDoc = await firestore
            .collection('students')
            .where('school_id', isEqualTo: userId.toString())
            .limit(1)
            .get();

        if (studentDoc.docs.isEmpty) {
          emit(ScheduleError("Student data not found"));
          return;
        }

        final studentData = studentDoc.docs.first.data();
        final studentGrade = studentData['grade_class'];
        scheduleQuery = scheduleQuery.where('grade', isEqualTo: studentGrade);
      } else if (role?.toLowerCase() == 'teacher') {
        // Fetch all schedules for teachers
        scheduleQuery = firestore.collection('schedules');
      } else if (role?.toLowerCase() == 'parent') {
        // Fetch all schedules for parents
        scheduleQuery = firestore.collection('schedules');
      } else {
        emit(ScheduleError("Invalid role"));
        return;
      }

      final snapshot = await scheduleQuery.get();
      final Map<String, List<Map<String, dynamic>>> scheduleData = {};

      for (var doc in snapshot.docs) {
        scheduleData[doc.id] = [{
          'subject': doc.data()['file_name'] ?? '',
          'time': '',
          'class': doc.data()['grade'] ?? '',
          'pdf_path': doc.data()['pdf_path'] ?? '',
        }];
      }

      emit(ScheduleLoaded(scheduleData));
    } catch (e) {
      emit(ScheduleError("Failed to fetch schedule: $e"));
    }
  }
}