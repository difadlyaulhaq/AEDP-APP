import 'package:flutter/material.dart';
import 'package:project_aedp/bloc/material_and_subject/subject_model.dart';
import 'package:project_aedp/pages/teacher/teacher_feature/teacher_detailmaterial.dart';

class MaterialCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onRefresh;

  const MaterialCard({
    super.key,
    required this.subject,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.book, color: Colors.white),
        ),
        title: Text(
          subject.subjectName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherDetailMaterial(
                subject: subject.subjectName,
                subjectId: subject.id,
                grade: subject.grade,
              ),
            ),
          );
          if (result == true) {
            onRefresh();
          }
        },
      ),
    );
  }
}
