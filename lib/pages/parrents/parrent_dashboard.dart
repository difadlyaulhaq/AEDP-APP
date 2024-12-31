import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/parrents/ParentGradesPage.dart';
import 'package:project_aedp/pages/profile_page.dart';
import 'package:project_aedp/pages/students/GradesPage.dart';
import 'package:project_aedp/pages/students/invoice_page.dart';
import 'package:project_aedp/pages/students/materialpage.dart';
import 'package:project_aedp/pages/students/schedulepage.dart';
import 'package:project_aedp/theme/theme.dart';

class DashboardParentHome extends StatelessWidget {
  const DashboardParentHome({super.key});

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
                  MaterialPageRoute(builder: (context) => const ParentGradesPage()),
                );
              }),
              _buildIconButton(context, Icons.assessment, 'Progress', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentProgressPage()),
                );
              }),
              _buildIconButton(context, Icons.fact_check, 'Attendance', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AttendancePage()),
                );
              }),
              _buildIconButton(context, Icons.notifications, S.of(context).notifications, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              }),
              _buildIconButton(context, Icons.library_books, S.of(context).e_library, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ELibraryPage()),
                );
              }),
              _buildIconButton(context, Icons.card_membership, 'Certificates', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CertificatesPage()),
                );
              }),
              _buildIconButton(context, Icons.insert_drive_file, S.of(context).reports, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportsPage()),
                );
              }),
            ],
          ),
        ),
      ],
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
            textAlign: TextAlign.center,
            style: blackColorTextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
}

// You'll need to create these pages:
class StudentProgressPage extends StatelessWidget {
  const StudentProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement student progress monitoring page
    return const Scaffold(
      body: Center(child: Text('Student Progress Page')),
    );
  }
}

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement attendance tracking page
    return const Scaffold(
      body: Center(child: Text('Attendance Page')),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement notifications page
    return const Scaffold(
      body: Center(child: Text('Notifications Page')),
    );
  }
}

class ELibraryPage extends StatelessWidget {
  const ELibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement e-library page
    return const Scaffold(
      body: Center(child: Text('E-Library Page')),
    );
  }
}

class CertificatesPage extends StatelessWidget {
  const CertificatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement certificates page
    return const Scaffold(
      body: Center(child: Text('Certificates Page')),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Implement reports page
    return const Scaffold(
      body: Center(child: Text('Reports Page')),
    );
  }
}