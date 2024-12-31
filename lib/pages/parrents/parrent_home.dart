import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/parrents/parrent_dashboard.dart';
import '../profile_page.dart';
import '../students/invoice_page.dart';

class ParrentHome extends StatefulWidget {
  const ParrentHome({super.key});

  @override
  State<ParrentHome> createState() => _ParrentHomeState();
}

class _ParrentHomeState extends State<ParrentHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardparrentHome (),
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
            title: Text(S.of(context).parent_dashboard),
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
    path.lineTo(0, size.height - 30); // Mengurangi tinggi
    path.quadraticBezierTo(0, size.height, 20, size.height); // Sesuaikan offset
    path.lineTo(size.width - 30, size.height); // Sesuaikan offset
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 20); // Mengurangi tinggi
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
