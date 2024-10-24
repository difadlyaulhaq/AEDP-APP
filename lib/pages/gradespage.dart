import 'package:flutter/material.dart';
import 'package:project_aedp/pages/invoice_page.dart';
import 'package:project_aedp/pages/profile_page.dart';
import 'package:project_aedp/theme/theme.dart';
import 'package:project_aedp/widget/bottom_navbar.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0), // Adjust the height as needed
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
                    Color(0xFF4A90E2), // Light blue color
                    Color(0xFF003C8F), // Darker blue color
                  ],
                ),
              ),
            ),
            title: const Text(
              'Grades', // Title can be dynamic based on _selectedIndex if needed
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
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

// Your DashboardStudentsHome widget
class DashboardStudentsHome extends StatelessWidget {
  const DashboardStudentsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Grades Page Content",
              style: blackColorTextStyle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Additional content for the grades can go here
      ],
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
