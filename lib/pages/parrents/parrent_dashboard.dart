import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/parrents/TranscriptPage.dart';
import 'package:project_aedp/pages/parrents/certificatepage.dart';

import 'package:project_aedp/pages/parrents/invoice_page.dart';
import 'package:project_aedp/pages/students/materialpage.dart';
import 'package:project_aedp/pages/students/schedulepage.dart';

class DashboardParentHome extends StatelessWidget {
  const DashboardParentHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            // Maksimal 2 tombol per baris
            crossAxisSpacing: screenWidth * 0.03,
            mainAxisSpacing: screenWidth * 0.03,
            padding: EdgeInsets.all(screenWidth * 0.04),
            children: [
              _buildIconButton(
                  context, Icons.calendar_today, S
                  .of(context)
                  .schedule, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SchedulePage()),
                );
              }),
              _buildIconButton(context, Icons.assignment, 
                  S.of(context).certificates,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CertificatePage()),
                    );
                  }),
              _buildIconButton(context, Icons.book, S
                  .of(context)
                  .materials,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentMaterialPage()),
                    );
                  }),
              _buildIconButton(context,
               Icons.file_copy_sharp,
                S.of(context).transcript,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TranscriptPage()),
                    );
                  }),
              _buildIconButton(context, Icons.receipt, S
                  .of(context)
                  .invoices,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InvoicePage()),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }

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
}
