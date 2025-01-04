import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/notfound.dart';
import 'package:project_aedp/pages/profile_page.dart';
import 'package:project_aedp/pages/teacher/teacher_materialpage.dart';
import 'package:project_aedp/pages/teacher/teacher_schedule.dart';
import 'package:project_aedp/theme/theme.dart';
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
    NotFoundPage(),
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
              icon: const Icon(Icons.calendar_month_rounded),
              label: S.of(context).nav_attendance,
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
  const DashboardStudentsHome({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final textDirection = Directionality.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: textDirection == TextDirection.rtl 
                ? Alignment.centerRight 
                : Alignment.centerLeft,
            child: Text(
              S.of(context).dashboard_todo_header,
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
              _buildTodoItem(
                S.of(context).todo_assignment1_title,
                S.of(context).todo_due_today,
                context
              ),
              _buildTodoItem(
                S.of(context).todo_online_learning4,
                S.of(context).todo_due_date("Oct 9"),
                context
              ),
              _buildTodoItem(
                S.of(context).todo_online_learning5,
                S.of(context).todo_due_date("Oct 16"),
                context
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: screenWidth > 600 ? 4 : 3,
            children: [
              _buildIconButton(
                Icons.calendar_today,
                S.of(context).dashboard_schedule,
                () {
                  dev.log("Navigating to Schedule");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeacherSchedule()),
                  );
                },
                context,
              ),
              _buildIconButton(
                Icons.book,
                S.of(context).dashboard_materials,
                () {
                  dev.log("Navigating to Materials");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeacherMaterialpage()),
                  );
                },
                context,
              ),
              _buildIconButton(
                Icons.check_circle_outline,
                S.of(context).dashboard_grades,
                () {
                  dev.log("Navigating to Grades");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotFoundPage()),
                  );
                },
                context,
              ),
              _buildIconButton(
                Icons.insert_drive_file,
                S.of(context).dashboard_reports,
                () {
                  dev.log("Reports button clicked");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotFoundPage()),
                  );
                },
                context,
              ),
              // _buildIconButton(
              //   Icons.notifications,
              //   S.of(context).dashboard_notifications,
              //   () {
              //     dev.log("Notifications button clicked");
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const NotFoundPage()),
              //     );
              //   },
              //   context,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodoItem(String title, String deadline, BuildContext context) {
    final textDirection = Directionality.of(context);
    
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: textDirection,
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

  Widget _buildIconButton(IconData icon, String label, VoidCallback onTap, BuildContext context) {
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
            textAlign: TextAlign.center,
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