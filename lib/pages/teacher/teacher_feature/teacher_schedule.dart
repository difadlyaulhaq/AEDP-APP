import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:project_aedp/bloc/schedule/schedule_event.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/widget/Teacher_schedule_widgets/schedule_loader.dart';

class TeacherSchedule extends StatelessWidget {
  const TeacherSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).teacherSchedule),
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
              child: const ScheduleLoader(),
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
}  
