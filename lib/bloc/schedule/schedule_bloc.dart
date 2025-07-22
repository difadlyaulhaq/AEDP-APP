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
      // ... (kode validasi userId dan pencarian role tetap sama)
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
      }
      // ... (logika untuk role teacher dan parent tetap sama)
      
      final snapshot = await scheduleQuery.get();
      
      // --- PERUBAHAN UTAMA DI SINI ---

      // 1. Buat List untuk menampung semua jadwal
      final List<Map<String, dynamic>> scheduleList = [];

      for (var doc in snapshot.docs) {
        // Tambahkan setiap jadwal ke dalam list
        scheduleList.add({
          // Tambahkan ID dokumen jika diperlukan di UI, contohnya untuk key
          'id': doc.id, 
          'subject': doc.data()['file_name'] ?? '',
          'time': '', // time bisa diisi jika ada datanya
          'class': doc.data()['grade'] ?? '',
          'pdf_path': doc.data()['pdf_path'] ?? '',
        });
      }

      // 2. Urutkan list berdasarkan 'grade'
      // Kita parse ke integer agar pengurutan numerik benar (misal: "10" setelah "9")
      scheduleList.sort((a, b) {
        final gradeA = int.tryParse(a['class'].toString()) ?? 0;
        final gradeB = int.tryParse(b['class'].toString()) ?? 0;
        return gradeA.compareTo(gradeB);
      });

      // 3. Emit state dengan list yang sudah terurut
      emit(ScheduleLoaded(scheduleList));

    } catch (e) {
      emit(ScheduleError("Failed to fetch schedule: $e"));
    }
  }
}