import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/profile_page.dart';
import 'package:project_aedp/pages/students/elibrary.dart';
import 'package:project_aedp/pages/students/schedulepage.dart';
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
    SchedulePage(),
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
  const DashboardStudentsHome({Key? key}) : super(key: key);

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
      appBar: AppBar(title: Text(S.of(context).teacher_dashboard,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),)),
      body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
        builder: (context, state) {
          if (state is LoadProfileLoaded) {
            final teacherClasses = state.profileData['classes'] as List<String>? ?? [];

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
                      MaterialPageRoute(builder: (context) => const TeacherSchedule()),
                    ),
                  ),
                  _buildIconButton(
                    context,
                    Icons.book,
                    S.of(context).dashboard_materials,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherMaterialPage(teacherClasses: teacherClasses.join(',')),  
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
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
// Custom clipper class to define the rounded corners for AppBar
class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // Start from the bottom-left corner
    path.quadraticBezierTo(
        0, size.height, 40, size.height); // Left corner curve
    path.lineTo(
        size.width - 40, size.height); // Straight line at the bottom middle
    path.quadraticBezierTo(size.width, size.height, size.width,
        size.height - 40); // Right corner curve
    path.lineTo(size.width, 0); // Straight line at the top-right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true; // Always reclip
}
