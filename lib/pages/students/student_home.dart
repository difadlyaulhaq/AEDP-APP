import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/students/dashboard_students.dart';
import 'package:project_aedp/pages/profile_page.dart';
import 'package:project_aedp/pages/students/schedulepage.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardStudentsHome(),
     const SchedulePage(),
    const ProfilePage(),
  ];

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
    // appBar: AppBar(title: Text(S.of(context).student_dashboard,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),)),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavbarTap,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: S.of(context).home),
          BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today), label: S.of(context).schedule),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: S.of(context).profile),
        ],
      ),
    );
  }
}

