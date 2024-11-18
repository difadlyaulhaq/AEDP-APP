import 'package:flutter/material.dart';
import 'package:project_aedp/pages/students/dashboard_students.dart';
import 'package:project_aedp/pages/students/invoice_page.dart';
import 'package:project_aedp/pages/students/profile_page.dart';
import 'package:project_aedp/widget/bottom_navbar.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _selectedIndex = 0; // Track the selected tab index
  final String name = "Difa Dlyaul Haq"; // Store the user's name

  // List of all the pages to navigate between
  final List<Widget> _pages = [
    const DashboardStudentsHome(), // Example Home Page (you can replace with your actual home page)
    const InvoicePage(),          // Invoice page
    const ProfilePage(),          // Profile page
  ];

  // Logic for onTap navigation
  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height using MediaQuery
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15), // Adjust AppBar height based on screen height
        child: ClipPath(
          clipper: CustomAppBarClipper(), // Custom clipper for rounded corners
          child: AppBar(
            automaticallyImplyLeading: false, // Removes the back button if any
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(30, 113, 162, 1), 
                    Color.fromRGBO(11, 42, 60, 1), 
                  ],
                ),
              ),
            ),
            title: Text(
              'Welcome, $name', // Use dynamic name here
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.06, // Adjust title font size based on screen width
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // Use IndexedStack to load the appropriate page
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: DashboardNavbar(
        selectedIndex: _selectedIndex,
        onTap: _onNavbarTap,
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
    path.lineTo(size.width, 0); // Go to the top-right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip as the shape doesn't change dynamically
  }
}
