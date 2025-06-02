import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/common/profile_page.dart';
import 'package:project_aedp/pages/teacher/teacher_feature/teacher_schedule.dart';
import 'package:project_aedp/pages/teacher/teacher_dashboard/teacher_home_menu_page.dart';
import 'dart:developer' as dev;

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    TeacherHomeMenuPage(),
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
