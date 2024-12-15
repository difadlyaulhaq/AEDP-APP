import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleRepository {
  final FirebaseFirestore firestore;

  ScheduleRepository({required this.firestore});

  Future<Map<String, List<Map<String, String>>>> fetchSchedule() async {
    final Map<String, List<Map<String, String>>> scheduleData = {};

    try {
      final snapshot = await firestore.collection('schedules').get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final day = doc.id;

        if (data.containsKey('schedule')) {
          final List<dynamic> scheduleList = data['schedule'];
          scheduleData[day] = scheduleList
              .map((item) => Map<String, String>.from(item as Map))
              .toList();
        }
      }
      return scheduleData;
    } catch (e) {
      print('Error fetching schedule: $e');
      rethrow;
    }
  }
}
