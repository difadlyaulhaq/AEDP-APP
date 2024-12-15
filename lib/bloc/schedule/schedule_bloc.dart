import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      final Map<String, List<Map<String, dynamic>>> scheduleData = {};
      final snapshot = await firestore.collection('schedules').get();

      for (var doc in snapshot.docs) {
        final day = doc.id;
        final data = List<Map<String, dynamic>>.from(doc['schedule']);
        scheduleData[day] = data;
      }

      emit(ScheduleLoaded(scheduleData));
    } catch (e) {
      emit(ScheduleError('Failed to fetch schedule: $e'));
    }
  }
}
