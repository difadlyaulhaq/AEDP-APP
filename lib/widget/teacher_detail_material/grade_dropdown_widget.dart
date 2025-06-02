// widgets/grade_dropdown_widget.dart
import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';

class GradeDropdownWidget extends StatelessWidget {
  final List<String> availableGrades;
  final String? selectedGrade;
  final bool isEnabled;
  final ValueChanged<String?> onChanged;

  const GradeDropdownWidget({
    super.key,
    required this.availableGrades,
    required this.selectedGrade,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGrade,
      decoration: InputDecoration(
        labelText: 'Class Grade*',
        prefixIcon: Icon(Icons.school, color: Theme.of(context).primaryColor),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: availableGrades.map((grade) {
        return DropdownMenuItem<String>(
          value: grade,
          child: Text('${S.of(context).classes} : $grade'),
        );
      }).toList(),
      onChanged: isEnabled ? onChanged : null,
    );
  }
}