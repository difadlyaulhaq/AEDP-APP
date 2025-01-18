// import 'package:cloud_firestore/cloud_firestore.dart';

// class ScheduleRepository {
//   final FirebaseFirestore firestore;

//   ScheduleRepository({required this.firestore});

//   Future<Map<String, List<Map<String, dynamic>>>> fetchSchedule(String userId) async {
//     final Map<String, List<Map<String, dynamic>>> scheduleData = {};

//     try {
//       // Ambil data pengguna berdasarkan ID
//       final userDoc = await firestore
//           .collection('users')
//           .where('id', isEqualTo: num.tryParse(userId))
//           .limit(1)
//           .get();

//       if (userDoc.docs.isEmpty) {
//         throw Exception("User not found");
//       }

//       final userData = userDoc.docs.first.data();
//       final role = userData['role'] as String?;

//       // Jika pengguna adalah "student", ambil grade mereka
//       String? studentGrade;
//       if (role?.toLowerCase() == 'student') {
//         final studentDoc = await firestore
//             .collection('students')
//             .where('school_id', isEqualTo: userId)
//             .limit(1)
//             .get();

//         if (studentDoc.docs.isEmpty) {
//           throw Exception("Student data not found");
//         }

//         final studentData = studentDoc.docs.first.data();
//         studentGrade = studentData['grade_class'];
//       }

//       // Ambil jadwal berdasarkan grade (jika student) atau semua jadwal (jika non-student)
//       Query<Map<String, dynamic>> scheduleQuery = firestore.collection('schedules');
//       if (studentGrade != null) {
//         scheduleQuery = scheduleQuery.where('grade', isEqualTo: studentGrade);
//       }

//       final snapshot = await scheduleQuery.get();

//       for (var doc in snapshot.docs) {
//         final day = doc.id;
//         final data = List<Map<String, dynamic>>.from(doc['schedule']);
//         scheduleData[day] = data;
//       }

//       return scheduleData;
//     } catch (e) {
//       print('Error fetching schedule: $e');
//       rethrow;
//     }
//   }
// }
