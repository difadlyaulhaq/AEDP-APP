import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/teacher/input_grade_page.dart';

class TeacherGradesPage extends StatefulWidget {
  final List<String> teacherClasses;
  const TeacherGradesPage({super.key, required this.teacherClasses});

  @override
  State<TeacherGradesPage> createState() => _TeacherGradesPageState();
}

class _TeacherGradesPageState extends State<TeacherGradesPage> {
  String? selectedClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).grades),
        backgroundColor: const Color(0xFF3F51B5),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3F51B5), Color(0xFF283593)],
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: selectedClass,
                decoration: InputDecoration(
                  // labelText: S.of(context).filterByClass,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(S.of(context).classes),
                  ),
                  ...widget.teacherClasses.map((cls) {
                    return DropdownMenuItem(
                      value: cls,
                      child: Text(cls),
                    );
                  }),
                ],
                onChanged: (value) => setState(() => selectedClass = value),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('students')
                      .where('grade_class', whereIn: selectedClass != null 
                          ? [selectedClass!] 
                          : widget.teacherClasses)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF3F51B5)),
                        ),
                      );
                    }

                    final students = snapshot.data?.docs ?? [];
                    final classStudents = <String, List<QueryDocumentSnapshot>>{};

                    for (final student in students) {
                      final gradeClass = student['grade_class'];
                      classStudents.putIfAbsent(gradeClass, () => []).add(student);
                    }

                    List<String> displayClasses = selectedClass != null
                        ? [selectedClass!]
                        : widget.teacherClasses;

                    return ListView.builder(
                      itemCount: displayClasses.length,
                      itemBuilder: (context, index) {
                        final className = displayClasses[index];
                        final studentsInClass = classStudents[className] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 8.0),
                              child: Text(
                                '${S.of(context).classes}: $className',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3F51B5)),
                              ),
                            ),
                            if (studentsInClass.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  S.of(context).noStudents,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              )
                            else
                              ...studentsInClass
                                  .map((student) =>
                                      _buildStudentCard(context, student))
                                  .toList(),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, QueryDocumentSnapshot student) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InputGrade(
                studentName: student['full_name'],
                schoolId: student['school_id'],
                gradeClass: student['grade_class'],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE8EAF6),
                child: Text(
                  student['full_name'].substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F51B5),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['full_name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context).schoolId(student['school_id']),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${S.of(context).classes}: ${student['grade_class']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F51B5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Text(
                      S.of(context).viewGrades,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xFF3F51B5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

