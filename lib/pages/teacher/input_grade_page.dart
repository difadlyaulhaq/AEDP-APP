import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_aedp/generated/l10n.dart';
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
  late TabController _tabController;
  
  // Controllers for all three possible periods
  final Map<String, Map<String, TextEditingController>> _controllersByExamType = {
    "first_period": {},
    "second_period": {},
    "third_period": {},
  };
  
  final Map<String, String> _subjectNames = {};
  final Map<String, Map<String, String>> _existingGradeIdsByExamType = {
    "first_period": {},
    "second_period": {},
    "third_period": {},
  };
  
  final Map<String, Map<String, String>> _existingGradesByExamType = {
    "first_period": {},
    "second_period": {},
    "third_period": {},
  };
  
  String _selectedExamType = "first_period";
  bool isPrimaryLevel = false;
  bool isSecondaryLevel = false;
  bool _isLoading = false;
  String _currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  int _coefficient = 3; // Default coefficient
  int _periodCount = 3; // Default period count
  
  @override
  void initState() {
    super.initState();
    // Determine grade level from class name
    int grade = int.tryParse(widget.gradeClass.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    isPrimaryLevel = grade >= 1 && grade <= 6;
    isSecondaryLevel = grade >= 7 && grade <= 12;
    
    // Set coefficient and period count based on grade level
    _coefficient = isPrimaryLevel ? 3 : 2;
    _periodCount = isPrimaryLevel ? 3 : 2;
    
    // Initialize tab controller with appropriate number of tabs
    _tabController = TabController(length: _periodCount, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedExamType = _getExamType(_tabController.index);
        _fetchSubjectsAndExistingGrades();
      });
    });
    
    _fetchSubjectsAndExistingGrades();
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _controllersByExamType.forEach((examType, controllers) {
      controllers.forEach((_, controller) => controller.dispose());
    });
    _tabController.dispose();
    super.dispose();
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
      // Fetch subjects for this class
      QuerySnapshot subjectDocs = await _firestore.collection('subjects').get();
      var filteredSubjects = subjectDocs.docs.where((doc) {
        String gradeStr = doc['grade'];
        List<String> grades = gradeStr.split(',');
        return grades.contains(widget.gradeClass);
      }).toList();
      
      // Ensure controllers exist for current exam type
      if (!_controllersByExamType.containsKey(_selectedExamType)) {
        _controllersByExamType[_selectedExamType] = {};
      }
      
      Map<String, TextEditingController> newControllers = {};
      Map<String, String> newSubjectNames = {};
      
      for (var doc in filteredSubjects) {
        String docId = doc.id;
        // Create controller if it doesn't exist
        if (!_controllersByExamType[_selectedExamType]!.containsKey(docId)) {
          _controllersByExamType[_selectedExamType]![docId] = TextEditingController();
        }
        
        newControllers[docId] = _controllersByExamType[_selectedExamType]![docId]!;
        newSubjectNames[docId] = doc['subject_name'];
      }
      
      // Fetch existing grades for this student and current exam type
      QuerySnapshot gradeDocs = await _firestore
          .collection('grades')
          .where('school_id', isEqualTo: widget.schoolId)
          .where('exam_type', isEqualTo: _selectedExamType)
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
        _subjectNames.clear();
        _subjectNames.addAll(newSubjectNames);
        
        // Update only the current exam type data
        _existingGradeIdsByExamType[_selectedExamType] = existingGradeIds;
        _existingGradesByExamType[_selectedExamType] = existingGrades;
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
      // Get current controllers and existing grade IDs
      Map<String, TextEditingController> currentControllers = _controllersByExamType[_selectedExamType] ?? {};
      Map<String, String> currentExistingGradeIds = _existingGradeIdsByExamType[_selectedExamType] ?? {};
      
      for (var entry in currentControllers.entries) {
        String subjectId = entry.key;
        String gradeValue = entry.value.text;
        
        if (gradeValue.isNotEmpty) {
          int? grade = int.tryParse(gradeValue);
          // Validate grade value (0-20)
          if (grade == null || grade < 0 || grade > 20) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).gradeValidation + ' (0-20)')),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
          
          if (currentExistingGradeIds.containsKey(subjectId)) {
            // Update existing grade
            await _firestore.collection('grades').doc(currentExistingGradeIds[subjectId]).update({
              'grade': gradeValue,
              'coefficient': _coefficient,
              'date_updated': _currentDate,
            });
          } else {
            // Add new grade - always include exam_type for both primary and secondary
            await _firestore.collection('grades').add({
              'school_id': widget.schoolId,
              'student_name': widget.studentName,
              'class': widget.gradeClass,
              'subject': _subjectNames[subjectId],
              'subjectId': subjectId,
              'grade': gradeValue,
              'coefficient': _coefficient,
              'date_added': _currentDate,
              'exam_type': _selectedExamType,
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
        title: Text('${S.of(context).grade}: ${widget.studentName}', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F51B5),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          tabs: _buildPeriodTabs(),
        ),
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
                // Changed this to use TabBarView with a modified content structure
                child: TabBarView(
                  controller: _tabController,
                  children: List.generate(_periodCount, (index) {
                    return _buildTabContent();
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted the tab content to a separate method for better organization
  Widget _buildTabContent() {
    return Column(
      children: [
        // Non-scrollable header part
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
                'Class ${widget.gradeClass} ',
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
        
        // Scrollable part (main content)
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student info card
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
                
                // Enter Grade header
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
                
                // Subjects list
                _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F51B5)),
                      ),
                    )
                  : _buildSubjectsList(),
              ],
            ),
          ),
        ),
        
        // Non-scrollable footer (submit button)
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

  // Build the appropriate number of period tabs based on grade level
  List<Widget> _buildPeriodTabs() {
    final List<Widget> tabs = [
      Tab(text: S.of(context).firstPeriod),
      Tab(text: S.of(context).secondPeriod),
    ];
    
    // Add third period tab for primary level only
    if (isPrimaryLevel) {
      tabs.add(Tab(text: S.of(context).thirdPeriod));
    }
    
    return tabs;
  }

  Widget _buildSubjectsList() {
    // Get current controllers based on selected exam type
    Map<String, TextEditingController> currentControllers = _controllersByExamType[_selectedExamType] ?? {};
    Map<String, String> currentExistingGrades = _existingGradesByExamType[_selectedExamType] ?? {};
    
    if (currentControllers.isEmpty) {
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

    return Column(
      children: currentControllers.entries.map((entry) {
        final subjectId = entry.key;
        final hasExistingGrade = currentExistingGrades.containsKey(subjectId);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_subjectNames[subjectId] ?? ''}',
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
      }).toList(),
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