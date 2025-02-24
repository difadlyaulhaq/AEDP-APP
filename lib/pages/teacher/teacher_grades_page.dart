import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:translator/translator.dart';
class TeacherGradesPage extends StatelessWidget {
  final List<String> teacherClasses; // Explicitly typed as List<String>
  const TeacherGradesPage({super.key, required this.teacherClasses});

  @override
  Widget build(BuildContext context) {
    final List<String> classList = teacherClasses;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).grades),
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
            return Center(child: Text(S.of(context).noStudents));
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
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${S.of(context).schoolId} ${student['school_id']}',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black)),
                      const SizedBox(height: 4),
                      Text('${S.of(context).classes} ${student['grade_class']}',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.blueAccent),
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
  final Map<String, String?> _existingGrades =
      {}; // Simpan ID nilai jika sudah ada

  @override
  void initState() {
    super.initState();
    _fetchSubjectsAndGrades();
  }



Future<void> _fetchSubjectsAndGrades() async {
  final translator = GoogleTranslator();
  final String selectedLanguage = "en"; // Gantilah dengan bahasa yang dipilih user

  // Fetch all subjects
  QuerySnapshot subjectDocs = await _firestore.collection('subjects').get();

  // Filter subjects sesuai kelas siswa
  var filteredSubjects = subjectDocs.docs.where((doc) {
    String gradeStr = doc['grade'];
    List<String> grades = gradeStr.split(',');
    return grades.contains(widget.gradeClass);
  }).toList();

  // Inisialisasi controller dan nama mata pelajaran
  for (var doc in filteredSubjects) {
    _controllers[doc.id] = TextEditingController();
    String subjectName = doc['subject_name'];

    // Terjemahkan jika bahasa yang dipilih bukan default
    if (selectedLanguage == 'ar') {
      subjectName = (await translator.translate(subjectName, to: 'ar')).text;
    } else if (selectedLanguage == 'en') {
      subjectName = (await translator.translate(subjectName, to: 'en')).text;
    } else if (selectedLanguage == 'pt') {
      subjectName = (await translator.translate(subjectName, to: 'pt')).text;
    }

    _subjectNames[doc.id] = subjectName;
  }

  // Fetch existing grades
  QuerySnapshot gradeDocs = await _firestore
      .collection('grades')
      .where('school_id', isEqualTo: widget.schoolId)
      .where('class', isEqualTo: widget.gradeClass)
      .get();

  // Update controllers dengan nilai yang sudah ada
  for (var doc in gradeDocs.docs) {
    String subjectId = doc['subjectId'];
    if (_controllers.containsKey(subjectId)) {
      _controllers[subjectId]!.text = doc['grade'];
      _existingGrades[subjectId] = doc.id;
    }
  }

  setState(() {});
}

  Future<void> _submitGrades() async {
    for (var entry in _controllers.entries) {
      String? gradeId = _existingGrades[entry.key];
      String gradeValue = entry.value.text;

      if (gradeValue.isNotEmpty) {
        if (gradeId != null) {
          // Update existing grade
          await _firestore.collection('grades').doc(gradeId).update({
            'grade': gradeValue,
          });
        } else {
          // Create new grade document
          await _firestore.collection('grades').add({
            'school_id': widget.schoolId,
            'student_name': widget.studentName,
            'class': widget.gradeClass,
            'subject': _subjectNames[entry.key],
            'subjectId': entry.key,
            'grade': gradeValue,
          });
        }
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nilai ${widget.studentName}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _controllers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildStudentInfoHeader(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildSubjectsList(),
                  ),
                  _buildSubmitButton(context),
                ],
              ),
            ),
    );
  }

  Widget _buildStudentInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.studentName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${S.of(context).schoolId} : ${widget.schoolId}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Text(
                '${S.of(context).gradeClass}: ${widget.gradeClass}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      itemCount: _controllers.entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = _controllers.entries.elementAt(index);
        return Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                controller: entry.value,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: _subjectNames[entry.key],
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  hintText: S.of(context).enterGrade,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  suffixIcon: Icon(
                    Icons.school_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'please enter grade';
                  final numericValue = int.tryParse(value);
                  if (numericValue == null) return 'must be a number';
                  if (numericValue < 0 || numericValue > 100) {
                    return S.of(context).enterGrade;
                  }
                  return null;
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24, top: 16),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save_alt_rounded, size: 20, color: Colors.white),
        label: Text(
          S.of(context).submitGrades,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          shadowColor: Colors.blueAccent.withOpacity(0.3),
        ),
        onPressed: () async {
          await _submitGrades();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).gradesUploaded),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }
}
