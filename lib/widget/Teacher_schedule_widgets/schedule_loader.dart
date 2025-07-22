import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:project_aedp/bloc/schedule/schedule_state.dart';
import 'package:project_aedp/widget/Teacher_schedule_widgets/class_card.dart';

class ScheduleLoader extends StatelessWidget {
  const ScheduleLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ScheduleLoaded) {
          final scheduleData = state.scheduleData;

          return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scheduleData.length,
              itemBuilder: (context, index) {
                final classInfo = scheduleData[index];
                return ClassCard(classInfo: classInfo);
              },
            );
        }

        if (state is ScheduleError) {
          return Center(child: Text(state.error));
        }

        return const Center(child: Text('No schedules available.'));
      },
    );
  }
}
