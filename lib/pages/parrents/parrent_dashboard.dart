import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/profile_page.dart';
import 'package:project_aedp/pages/students/GradesPage.dart';
import 'package:project_aedp/pages/students/invoice_page.dart';
import 'package:project_aedp/pages/students/materialpage.dart';
import 'package:project_aedp/pages/students/schedulepage.dart';
import 'package:project_aedp/theme/theme.dart';

class ParrentDashboard extends StatefulWidget {
  const ParrentDashboard({super.key});

  @override
  State<ParrentDashboard> createState() => _ParrentDashboardState();
}

class _ParrentDashboardState extends State<ParrentDashboard> {
    int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardparrentHome(),
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
              icon: const Icon(Icons.receipt_long),
              label: S.of(context).nav_invoice,
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

class DashboardparrentHome extends StatelessWidget {
  const DashboardparrentHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: screenWidth > 600 ? 4 : 3,
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenWidth * 0.03,
            padding: EdgeInsets.all(screenWidth * 0.04),
            children: [
              _buildIconButton(context, Icons.calendar_today, S.of(context).schedule, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SchedulePage()),
                );
              }),
              _buildIconButton(context, Icons.book, S.of(context).materials, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentMaterialPage()),
                );
              }),
              _buildIconButton(context, Icons.check_circle_outline, S.of(context).grades, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GradesPage()),
                );
              }),
              _buildIconButton(context, Icons.insert_drive_file, S.of(context).reports, () {
                // Navigate or display message for "Reports"
              }),
              _buildIconButton(context, Icons.notifications, S.of(context).notifications, () {
                // Navigate or display message for "Notifications"
              }),
              _buildIconButton(context, Icons.library_books, S.of(context).e_library, () {
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
