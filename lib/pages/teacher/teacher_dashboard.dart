import 'package:flutter/material.dart';
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
    // Remove MaterialApp and use Scaffold directly
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
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
      ),
    );
  }
}

class DashboardStudentsHome extends StatelessWidget {
  const DashboardStudentsHome({Key? key}) : super(key: key);

  Widget _buildIconButton(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenWidth * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(51),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFF1E71A2),
              size: screenWidth * 0.08,
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).teacher_dashboard),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: screenWidth > 600 ? 4 : 3,
          crossAxisSpacing: 16.0, // Add horizontal spacing
          mainAxisSpacing: 16.0, // Add vertical spacing
          children: [
            _buildIconButton(
              context,
              Icons.calendar_today,
              S.of(context).dashboard_schedule,
              () {
                dev.log("Navigating to Schedule");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeacherSchedule()),
                );
              },
            ),
            _buildIconButton(
              context,
              Icons.book,
              S.of(context).dashboard_materials,
              () {
                dev.log("Navigating to Materials");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeacherMaterialPage()),
                );
              },
            ),
            _buildIconButton(
                context, Icons.library_books, S.of(context).e_library, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ELibraryPage()),
              );
            }
            ),
            // _buildIconButton(
            //   context,
            //   Icons.check_circle_outline,
            //   S.of(context).dashboard_grades,
            //   () {
            //     dev.log("Navigating to Grades");
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const NotFoundPage()),
            //     );
            //   },
            // ),
            // _buildIconButton(
            //   context,
            //   Icons.insert_drive_file,
            //   S.of(context).dashboard_reports,
            //   () {
            //     dev.log("Reports button clicked");
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const NotFoundPage()),
            //     );
            //   },
            // ),
          ],
        ),
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
