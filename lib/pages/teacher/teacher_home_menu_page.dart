import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/students/elibrary.dart';
import 'package:project_aedp/pages/teacher/teacher_grades_page.dart';
import 'package:project_aedp/pages/teacher/teacher_materialpage.dart';
import 'package:project_aedp/pages/teacher/teacher_schedule.dart';
import 'package:project_aedp/widget/dashboard/dashboard_icon_button.dart';

class TeacherHomeMenuPage extends StatelessWidget {
  const TeacherHomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).teacher_dashboard,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
        builder: (context, state) {
          if (state is LoadProfileLoaded) {
            final teacherClassesRaw = state.profileData['classes'];
            final List<String> teacherClasses = teacherClassesRaw is String
                ? teacherClassesRaw.split(',').map((e) => e.trim()).toList()
                : (teacherClassesRaw is List)
                    ? teacherClassesRaw.cast<String>()
                    : [];

            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  DashboardIconButton(
                    icon: Icons.calendar_today,
                    label: S.of(context).dashboard_schedule,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TeacherSchedule(),
                        ),
                      );
                    },
                  ),
                  DashboardIconButton(
                    icon: Icons.book,
                    label: S.of(context).dashboard_materials,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TeacherMaterialPage(
                            teacherClasses: teacherClasses,
                          ),
                        ),
                      );
                    },
                  ),
                  DashboardIconButton(
                    icon: Icons.library_books,
                    label: S.of(context).e_library,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ELibraryPage(),
                        ),
                      );
                    },
                  ),
                  DashboardIconButton(
                    icon: Icons.school,
                    label: S.of(context).grade,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TeacherGradesPage(
                            teacherClasses: teacherClasses,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
