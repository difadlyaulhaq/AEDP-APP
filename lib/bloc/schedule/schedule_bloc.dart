import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final FirebaseFirestore firestore;

  ScheduleBloc({required this.firestore}) : super(ScheduleInitial()) {
    on<FetchSchedule>(_onFetchSchedule);
    on<DownloadSchedule>(_onDownloadSchedule);
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
      }else if (role?.toLowerCase() == 'parent') {
        // Fetch all schedules for parents
        scheduleQuery = firestore.collection('schedules');
      }else {
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

  Future<void> _onDownloadSchedule(
    DownloadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(event.filePath).toString();

      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        final directory = Platform.isAndroid
            ? Directory('/storage/emulated/0/Download')
            : await getApplicationDocumentsDirectory();

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final fileName = event.filePath.split('/').last;
        final filePathToSave = '${directory.path}/$fileName';
        final file = File(filePathToSave);
        await file.writeAsBytes(response.bodyBytes);

        emit(ScheduleDownloaded(filePathToSave));
      } else {
        emit(ScheduleError("Failed to download schedule: ${response.statusCode}"));
      }
    } catch (e) {
      emit(ScheduleError("Error downloading schedule: $e"));
    }
  }
}
