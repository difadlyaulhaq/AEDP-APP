import 'package:flutter/material.dart';
import 'package:project_aedp/pages/students/GradesPage.dart';
import 'package:project_aedp/pages/students/invoice_page.dart';
import 'package:project_aedp/pages/students/materialpage.dart';
import 'package:project_aedp/pages/students/profile_page.dart';
import 'package:project_aedp/pages/students/schedulepage.dart';
import 'package:project_aedp/theme/theme.dart';

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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF003C8F),
            ],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavbarTap,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Invoice',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardStudentsHome extends StatelessWidget {
  const DashboardStudentsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "To-Do:",
              style: blackColorTextStyle.copyWith(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              _buildTodoItem("Assignment 1", "Due today, 23.59"),
              _buildTodoItem("Online Learning #04", "Due Oct 9, 23.59"),
              _buildTodoItem("Online Learning #05", "Due Oct 16, 23.59"),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Expanded(
          child: GridView.count(
            crossAxisCount: screenWidth > 600 ? 4 : 3,
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenWidth * 0.03,
            padding: EdgeInsets.all(screenWidth * 0.04),
            children: [
              _buildIconButton(context, Icons.calendar_today, "Schedule", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SchedulePage()),
                );
              }),
              _buildIconButton(context, Icons.book, "Materials", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentMaterialPage()),
                );
              }),
              _buildIconButton(context, Icons.check_circle_outline, "Grades", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Gradespage()),
                );
              }),
              _buildIconButton(context, Icons.insert_drive_file, "Reports", () {
                // Navigate or display message for "Reports"
              }),
              _buildIconButton(context, Icons.notifications, "Notifications", () {
                // Navigate or display message for "Notifications"
              }),
              _buildIconButton(context, Icons.library_books, "E-Library", () {
                // Navigate or display message for "E-Library"
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodoItem(String title, String deadline) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: blackColorTextStyle.copyWith(fontSize: 16),
              ),
            ),
            Text(
              deadline,
              style: blackColorTextStyle.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: CircleAvatar(
              backgroundColor: bluecolor,
              radius: MediaQuery.of(context).size.width * 0.08,
              child: Icon(
                icon,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: blackColorTextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
        ],
      ),
    );
  }
}
