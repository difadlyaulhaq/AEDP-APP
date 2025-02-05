import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/bloc/teacher_materi/material_event.dart';
import 'package:project_aedp/bloc/teacher_materi/material_state.dart' as custom;
import 'package:project_aedp/bloc/teacher_materi/teacher_bloc.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/parrents/invoice_page.dart';
import 'package:project_aedp/pages/students/elibrary.dart';
import 'package:project_aedp/pages/students/materialpage.dart';
import 'package:project_aedp/pages/profile_page.dart';
import 'package:project_aedp/pages/students/schedulepage.dart';

import '../../bloc/teacher_materi/material_state.dart';

class DashboardStudents extends StatefulWidget {
  const DashboardStudents({super.key});

  @override
  State<DashboardStudents> createState() => _DashboardStudentsState();
}

class _DashboardStudentsState extends State<DashboardStudents> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardStudentsHome(),
    InvoicePage(),
    ProfilePage(),
  ];

  void _onNavbarTap(int index) {
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
            icon: const Icon(Icons.receipt_long),
            label: S.of(context).nav_invoice,
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
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).student_dashboard)),
      body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
        builder: (context, state) {
          if (state is LoadProfileLoaded) {
            final studentGradeClass = state.profileData['grade_class'] ?? '';

            return BlocProvider(
              create: (context) => MaterialBloc()
                ..add(FetchSubjects(isTeacher: false, studentGradeClass: studentGradeClass, teacherClasses: '')), 
              child: BlocBuilder<MaterialBloc, custom.MaterialState>(
                builder: (context, materialState) {
                  if (materialState is SubjectsLoaded) {
                    final subjects = materialState.subjects;

                    return GridView.count(
                      crossAxisCount: 3,
                      children: [
                        _buildIconButton(
                          context,
                          Icons.calendar_today,
                          S.of(context).dashboard_schedule,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SchedulePage()),
                          ),
                        ),
                        _buildIconButton(
                          context,
                          Icons.book,
                          S.of(context).materials,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentMaterialPage( studentGradeClass: studentGradeClass ),
                            ),
                          ),
                        ),
                        _buildIconButton(
                          context,
                          Icons.library_books,
                          S.of(context).e_library,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ELibraryPage()),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
