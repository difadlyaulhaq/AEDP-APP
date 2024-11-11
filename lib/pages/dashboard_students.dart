import 'package:flutter/material.dart';
import 'package:project_aedp/pages/GradesPage.dart';
import 'package:project_aedp/pages/invoice_page.dart';
import 'package:project_aedp/pages/materialpage.dart';
import 'package:project_aedp/pages/profile_page.dart';
import 'package:project_aedp/pages/schedulepage.dart';
import 'package:project_aedp/theme/theme.dart';

class DashboardStudents extends StatefulWidget {
  const DashboardStudents({super.key});

  @override
  State<DashboardStudents> createState() => _DashboardStudentsState();
}

class _DashboardStudentsState extends State<DashboardStudents> {
  int _selectedIndex = 0; // Track the selected tab index

  // List of all the pages to navigate between
  final List<Widget> _pages = const [
    DashboardStudentsHome(), // Home page
    InvoicePage(), // Invoice page
    ProfilePage(), // Profile page
  ];

  // Logic for onTap navigation
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
          children: _pages, // Use IndexedStack to load the appropriate page
        ),
        // Bottom Navigation Bar
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
                Color(0xFF4A90E2), // Light blue color
                Color(0xFF003C8F), // Darker blue color
              ],
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex, // Track the selected page index
            onTap: _onNavbarTap, // Triggered when an item is tapped
            backgroundColor: Colors
                .transparent, // Make background transparent for gradient effect
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

// A separate widget for the Dashboard's Home Page
class DashboardStudentsHome extends StatelessWidget {
  const DashboardStudentsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // To-Do Section
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
        // Icon Buttons
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            children: [
              _buildIconButton(Icons.calendar_today, "Schedule", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SchedulePage()),
                );
              }),
              _buildIconButton(Icons.book, "Materials", () {
                // Navigate to Material_page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Material_page()),
                );
              }),
              _buildIconButton(Icons.check_circle_outline, "Grades", () {
                // Navigate to GradesPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Gradespage()),
                );
              }),
              _buildIconButton(Icons.insert_drive_file, "Reports", () {
                // Navigate or display message for "Reports"
              }),
              _buildIconButton(Icons.notifications, "Notifications", () {
                // Navigate or display message for "Notifications"
              }),
              _buildIconButton(Icons.library_books, "E-Library", () {
                // Navigate or display message for "E-Library"
              }),
            ],
          ),
        ),
      ],
    );
  }

  // Helper function to build To-Do list items
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

  // Helper function to build icon buttons with onTap functionality
  Widget _buildIconButton(IconData icon, String label, VoidCallback onTap) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap, // Action when the icon is tapped
            borderRadius: BorderRadius.circular(30), // Match CircleAvatar radius
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
