// widgets/student_info_card.dart
import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';

class StudentInfoCard extends StatelessWidget {
  final String studentName;
  final String schoolId;
  final String gradeClass;
  final String currentDate;

  const StudentInfoCard({
    super.key,
    required this.studentName,
    required this.schoolId,
    required this.gradeClass,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              icon: Icons.person,
              text: studentName,
              isTitle: true,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.badge,
              text: S.of(context).schoolId(schoolId),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.calendar_today,
              text: 'Date: $currentDate',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isTitle = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF3F51B5)),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: isTitle ? 16 : 14,
            fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
            color: isTitle ? Colors.black87 : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}