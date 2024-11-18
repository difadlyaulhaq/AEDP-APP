import 'package:flutter/material.dart';
import 'package:project_aedp/pages/students/invoice_page.dart';
import 'package:project_aedp/pages/students/profile_page.dart';
import 'package:project_aedp/pages/teacher/teacher_grade_pages.dart';
import 'package:project_aedp/pages/teacher/teacher_materialpage.dart';
import 'package:project_aedp/pages/teacher/teacher_schedule.dart';
import 'package:project_aedp/theme/theme.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
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
    return Material(
      child: Scaffold(
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
      ),
    );
  }
}

class DashboardStudentsHome extends StatelessWidget {
  const DashboardStudentsHome({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "To-Do:",
              style: blackColorTextStyle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(16.0),
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
        const SizedBox(height: 20),
        // Icon Buttons with responsive Grid
        Expanded(
          child: GridView.count(
            crossAxisCount: screenWidth > 600 ? 4 : 3, // 4 columns on large screens, 3 on smaller ones
            children: [
              _buildIconButton(Icons.calendar_today, "Schedule", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeacherSchedule()),
                );
              }),
              _buildIconButton(Icons.book, "Materials", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeacherMaterialpage()),
                );
              }),
              _buildIconButton(Icons.check_circle_outline, "Grades", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeacherGradePages()),
                );
              }),
              _buildIconButton(Icons.insert_drive_file, "Reports", () {
                // Navigate or display message for "Reports"
              }),
              _buildIconButton(Icons.notifications, "Notifications", () {
                // Navigate or display message for "Notifications"
              }),
              _buildIconButton(Icons.calendar_month_rounded, "Attendance", () {
                // Navigate or display message for "Attendance"
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
            Text(
              title,
              style: blackColorTextStyle.copyWith(fontSize: 16),
            ),
            Text(
              deadline,
              style: blackColorTextStyle.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onTap) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: CircleAvatar(
              backgroundColor: bluecolor,
              radius: 30,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: blackColorTextStyle.copyWith(fontSize: 14),
          ),
        ],
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
    path.quadraticBezierTo(0, size.height, 40, size.height); // Left corner curve
    path.lineTo(size.width - 40, size.height); // Straight line at the bottom middle
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40); // Right corner curve
    path.lineTo(size.width, 0); // Straight line at the top-right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true; // Always reclip
}
