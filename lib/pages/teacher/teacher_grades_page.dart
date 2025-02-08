import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherGradesPage extends StatelessWidget {
  final String teacherClasses;

  const TeacherGradesPage({super.key, required this.teacherClasses});

  @override
  Widget build(BuildContext context) {
    List<String> classList = teacherClasses.split(',');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Grades Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .where('grade_class', whereIn: classList)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No students found'));
          }
          
          var students = snapshot.data!.docs;
          
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var student = students[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(student['full_name'],
                      style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('School ID: ${student['school_id']}',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text('Class: ${student['grade_class']}',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class InputGrade extends StatefulWidget {
  final String studentName;
  final String schoolId;
  final String gradeClass;

  const InputGrade({
    super.key,
    required this.studentName,
    required this.schoolId,
    required this.gradeClass,
  });

  @override
  State<InputGrade> createState() => _InputGradeState();
}

class _InputGradeState extends State<InputGrade> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _subjectNames = {};
  
  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    QuerySnapshot subjectDocs = await _firestore
        .collection('subjects')
        .where('grade', isEqualTo: widget.gradeClass)
        .get();
    
    setState(() {
      for (var doc in subjectDocs.docs) {
        _controllers[doc.id] = TextEditingController();
        _subjectNames[doc.id] = doc['subject_name'];
      }
    });
  }

  Future<void> _submitGrades() async {
    for (var entry in _controllers.entries) {
      await _firestore.collection('grades').add({
        'school_id': widget.schoolId,
        'student_name': widget.studentName,
        'class': widget.gradeClass,
        'subject': _subjectNames[entry.key],
        'subjectId': entry.key,
        'grade': entry.value.text,
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Grades for ${widget.studentName}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _controllers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: _controllers.entries.map((entry) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextField(
                              controller: entry.value,
                              decoration: InputDecoration(
                                labelText: _subjectNames[entry.key],
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitGrades,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Submit Grades',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
