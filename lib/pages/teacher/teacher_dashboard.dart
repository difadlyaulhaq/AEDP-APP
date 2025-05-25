  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
  import 'package:project_aedp/bloc/load_profile/profile_state.dart';
  import 'package:project_aedp/generated/l10n.dart';
  import 'package:project_aedp/pages/common/profile_page.dart';
  import 'package:project_aedp/pages/students/elibrary.dart';
  import 'package:project_aedp/pages/teacher/teacher_grades_page.dart';
  import 'package:project_aedp/pages/teacher/teacher_materialpage.dart';
  import 'package:project_aedp/pages/teacher/teacher_schedule.dart';

  import 'dart:developer' as dev;

  class TeacherDashboard extends StatefulWidget {
    const TeacherDashboard({super.key});

    @override
    State<TeacherDashboard> createState() => _TeacherDashboardState();
  }

  class _TeacherDashboardState extends State<TeacherDashboard> {
    int _selectedIndex = 0;

    final List<Widget> _pages = const [
      DashboardStudentsHome(),
      TeacherSchedule(),
      ProfilePage(),
    ];

    void _onNavbarTap(int index) {
      dev.log("Navigation tab tapped: $index");
      setState(() {
        _selectedIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavbarTap,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: S.of(context).nav_home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today),
              label: S.of(context).schedule,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: S.of(context).nav_profile,
            ),
          ],
        ),
      );
    }
  }

  class DashboardStudentsHome extends StatelessWidget {
    const DashboardStudentsHome({super.key});

    Widget _buildIconButton(
        BuildContext context, IconData icon, String label, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).teacher_dashboard,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
        ),
        body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
          builder: (context, state) {
            if (state is LoadProfileLoaded) {
              // Ensure teacherClasses is not null and is explicitly typed as List<String>
              final teacherClassesRaw = state.profileData['classes'];
              final List<String> teacherClasses = teacherClassesRaw is String
                  ? teacherClassesRaw.split(',').map((e) => e.trim()).toList()
                  : (teacherClassesRaw is List)
                      ? teacherClassesRaw.cast<String>() // Cast to List<String>
                      : [];

              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    _buildIconButton(
                      context,
                      Icons.calendar_today,
                      S.of(context).dashboard_schedule,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TeacherSchedule()),
                      ),
                    ),
                    _buildIconButton(
                      context,
                      Icons.book,
                      S.of(context).dashboard_materials,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherMaterialPage(
                            teacherClasses: teacherClasses,
                          ),
                        ),
                      ),
                    ),
                    _buildIconButton(
                      context,
                      Icons.library_books,
                      S.of(context).e_library,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ELibraryPage()),
                      ),
                    ),
                                     _buildIconButton(
                    context,
                    Icons.school,
                    S.of(context).grade,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TeacherGradesPage(teacherClasses: teacherClasses),
                      ),
                    ),
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
  