import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/students/dashboard_students.dart';
import 'package:project_aedp/pages/parrents/invoice_page.dart';
import 'package:project_aedp/pages/profile_page.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardStudentsHome(),
    const InvoicePage(),
    const ProfilePage(),
  ];

  void _onNavbarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15),
        child: ClipPath(
          clipper: CustomAppBarClipper(),
          child: AppBar(
            title: Text(S.of(context).student_dashboard),
            centerTitle: true,
            toolbarHeight: 60,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E71A2), Color(0xFF0B2A3C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ),
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
              icon: const Icon(Icons.receipt), label: S.of(context).invoices),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person), label: S.of(context).profile),
        ],
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20); // Mengurangi tinggi
    path.quadraticBezierTo(0, size.height, 20, size.height); // Sesuaikan offset
    path.lineTo(size.width - 20, size.height); // Sesuaikan offset
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 20); // Mengurangi tinggi
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
