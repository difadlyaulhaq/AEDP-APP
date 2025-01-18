import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:project_aedp/bloc/schedule/schedule_event.dart';
import 'package:project_aedp/bloc/schedule/schedule_state.dart';

class TeacherSchedule extends StatelessWidget {
  const TeacherSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Schedule'),
        backgroundColor: const Color(0xFF1E71A2),
        centerTitle: true,
      ),
      body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
        builder: (context, profileState) {
          if (profileState is LoadProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileState is LoadProfileLoaded) {
            final teacherId = profileState.profileData['id'];

            return BlocProvider(
              create: (context) {
                final scheduleBloc = ScheduleBloc(firestore: context.read());
                scheduleBloc.add(FetchSchedule(userId: teacherId));
                return scheduleBloc;
              },
              child: BlocBuilder<ScheduleBloc, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ScheduleLoaded) {
                    final scheduleData = state.scheduleData;

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: scheduleData.values.expand((daySchedule) {
                        return daySchedule.map((classInfo) {
                          return _buildClassCard(classInfo);
                        }).toList();
                      }).toList(),
                    );
                  }

                  if (state is ScheduleError) {
                    return Center(child: Text(state.error));
                  }

                  return const Center(child: Text('No schedules available.'));
                },
              ),
            );
          }

          if (profileState is LoadProfileError) {
            return Center(child: Text(profileState.message));
          }

          return const Center(child: Text('No profile data available.'));
        },
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classInfo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classInfo['subject'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Grade: ${classInfo['class']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (classInfo['pdf_path'] != null)
              ElevatedButton.icon(
                onPressed: () {
                  // Handle download logic
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Schedule'),
              ),
          ],
        ),
      ),
    );
  }
}
