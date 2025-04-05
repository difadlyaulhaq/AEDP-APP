import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_aedp/generated/l10n.dart';

class TeacherGradesPage extends StatelessWidget {
  final List<String> teacherClasses;
  const TeacherGradesPage({super.key, required this.teacherClasses});

  @override
  Widget build(BuildContext context) {
    final List<String> classList = teacherClasses;

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
                      .where('grade_class', whereIn: classList)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F51B5)),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              S.of(context).noStudents,
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

                    // Group students by class
                    var students = snapshot.data!.docs;
                    Map<String, List<QueryDocumentSnapshot>> classStudents = {};
                    for (var student in students) {
                      String gradeClass = student['grade_class'];
                      classStudents.putIfAbsent(gradeClass, () => []).add(student);
                    }

                    // Sort classes according to teacherClasses order
                    List<String> sortedClasses = classList.where((c) => classStudents.containsKey(c)).toList();

                    return ListView.builder(
                      itemCount: sortedClasses.length,
                      itemBuilder: (context, index) {
                        String className = sortedClasses[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              child: Text(
                                '${S.of(context).classes} : $className',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3F51B5),
                                ),
                              ),
                            ),
                            ...classStudents[className]!.map((student) => _buildStudentCard(context, student)).toList(),
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
                      '${S.of(context).schoolId(student['school_id'])}',
                      style: TextStyle(
                        fontSize: 10,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

class _InputGradeState extends State<InputGrade> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController? _tabController;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _subjectNames = {};
  final Map<String, String> _existingGradeIds = {}; // Store existing grade document IDs
  final Map<String, String> _existingGrades = {}; // Store existing grade values
  String _selectedExamType = "first_period";
  bool isPrimaryLevel = false;
  bool _isLoading = false;
  String _currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    int grade = int.tryParse(widget.gradeClass) ?? 0;
    isPrimaryLevel = grade >= 1 && grade <= 6;
    if (isPrimaryLevel) {
      _tabController = TabController(length: 3, vsync: this);
      _tabController!.addListener(() {
        setState(() {
          _selectedExamType = _getExamType(_tabController!.index);
          _fetchSubjectsAndExistingGrades();
        });
      });
    }
    _fetchSubjectsAndExistingGrades();
  }

  String _getExamType(int index) {
    switch (index) {
      case 0:
        return "first_period";
      case 1:
        return "second_period";
      case 2:
        return "third_period";
      default:
        return "first_period";
    }
  }

  Future<void> _fetchSubjectsAndExistingGrades() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Fetch subjects
      QuerySnapshot subjectDocs = await _firestore.collection('subjects').get();
      var filteredSubjects = subjectDocs.docs.where((doc) {
        String gradeStr = doc['grade'];
        List<String> grades = gradeStr.split(',');
        return grades.contains(widget.gradeClass);
      }).toList();
      
      Map<String, TextEditingController> newControllers = {};
      Map<String, String> newSubjectNames = {};
      
      for (var doc in filteredSubjects) {
        newControllers[doc.id] = _controllers[doc.id] ?? TextEditingController();
        newSubjectNames[doc.id] = doc['subject_name'];
      }
      
      // Fetch existing grades for this student
      QuerySnapshot gradeDocs = await _firestore
          .collection('grades')
          .where('school_id', isEqualTo: widget.schoolId)
          .where('exam_type', isEqualTo: isPrimaryLevel ? _selectedExamType : null)
          .get();
      
      Map<String, String> existingGradeIds = {};
      Map<String, String> existingGrades = {};
      
      for (var doc in gradeDocs.docs) {
        String subjectId = doc['subjectId'];
        if (newSubjectNames.containsKey(subjectId)) {
          existingGradeIds[subjectId] = doc.id;
          existingGrades[subjectId] = doc['grade'];
          // Set controller text to existing grade
          if (newControllers.containsKey(subjectId)) {
            newControllers[subjectId]!.text = doc['grade'];
          }
        }
      }
      
      setState(() {
        _controllers.clear();
        _controllers.addAll(newControllers);
        _subjectNames.clear();
        _subjectNames.addAll(newSubjectNames);
        _existingGradeIds.clear();
        _existingGradeIds.addAll(existingGradeIds);
        _existingGrades.clear();
        _existingGrades.addAll(existingGrades);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _submitGrades() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      for (var entry in _controllers.entries) {
        String subjectId = entry.key;
        String gradeValue = entry.value.text;
        
        if (gradeValue.isNotEmpty) {
          int? grade = int.tryParse(gradeValue);
          // Maximum grade set to 20 as requested
          if (grade == null || grade < 0 || grade > 20) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).gradeValidation + ' (0-20)')),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
          
          if (_existingGradeIds.containsKey(subjectId)) {
            // Update existing grade
            await _firestore.collection('grades').doc(_existingGradeIds[subjectId]).update({
              'grade': gradeValue,
              'date_updated': _currentDate,
            });
          } else {
            // Add new grade
            await _firestore.collection('grades').add({
              'school_id': widget.schoolId,
              'student_name': widget.studentName,
              'class': widget.gradeClass,
              'subject': _subjectNames[subjectId],
              'subjectId': subjectId,
              'grade': gradeValue,
              'exam_type': isPrimaryLevel ? _selectedExamType : null,
              'date_added': _currentDate,
            });
          }
        }
      }
      
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).gradesUploaded),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${S.of(context).grade}: ${widget.studentName}'),
        backgroundColor: const Color(0xFF3F51B5),
        elevation: 0,
        bottom: isPrimaryLevel
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                indicatorColor: Colors.amber,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: S.of(context).firstPeriod),
                  Tab(text: S.of(context).secondPeriod),
                  Tab(text: S.of(context).thirdPeriod),
                ],
              )
            : null,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3F51B5), Color(0xFF283593)],
            stops: [0.0, 0.3],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).studentInfo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F51B5),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Class ${widget.gradeClass}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Card(
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
                            Row(
                              children: [
                                const Icon(Icons.person, color: Color(0xFF3F51B5)),
                                const SizedBox(width: 8),
                                Text(
                                  widget.studentName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.badge, color: Color(0xFF3F51B5)),
                                const SizedBox(width: 8),
                                Text(
                                  S.of(context).schoolId(widget.schoolId),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Color(0xFF3F51B5)),
                                const SizedBox(width: 8),
                                Text(
                                  'Date: $_currentDate',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).enterGrade,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.of(context).maxGrade20,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F51B5)),
                              ),
                            )
                          : _buildSubjectsList(),
                    ),
                    const SizedBox(height: 16),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectsList() {
    if (_controllers.isEmpty) {
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

    return ListView.builder(
      itemCount: _controllers.length,
      itemBuilder: (context, index) {
        final entry = _controllers.entries.elementAt(index);
        final subjectId = entry.key;
        final hasExistingGrade = _existingGrades.containsKey(subjectId);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _subjectNames[subjectId] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (hasExistingGrade)
                    Container(
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
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: entry.value,
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitGrades,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3F51B5),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    S.of(context).uploading,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(
                S.of(context).submitGrades,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}