// widgets/subjects_list.dart
import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';

class SubjectsList extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final Map<String, String> subjectNames;
  final Map<String, String> existingGrades;

  const SubjectsList({
    super.key,
    required this.controllers,
    required this.subjectNames,
    required this.existingGrades,
  });

  @override
  Widget build(BuildContext context) {
    if (controllers.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: controllers.entries.map((entry) {
        return _buildSubjectItem(context, entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subject_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No subjects found for this class",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectItem(BuildContext context, String subjectId, TextEditingController controller) {
    final hasExistingGrade = existingGrades.containsKey(subjectId);
    final subjectName = subjectNames[subjectId] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubjectHeader(context, subjectName, hasExistingGrade),
          const SizedBox(height: 8),
          _buildGradeInput(context, controller),
        ],
      ),
    );
  }

  Widget _buildSubjectHeader(BuildContext context, String subjectName, bool hasExistingGrade) {
    return Row(
      children: [
        Expanded(
          child: Text(
            subjectName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        if (hasExistingGrade) _buildExistingGradeBadge(context),
      ],
    );
  }

  Widget _buildExistingGradeBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            S.of(context).previouslyGraded,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeInput(BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: S.of(context).enterGradeValue,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: const Icon(
          Icons.edit,
          color: Color(0xFF3F51B5),
        ),
        helperText: '${S.of(context).maxGradeValue}: 20',
        helperStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}