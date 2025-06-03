import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/models/grade/grade_model.dart';
import 'package:project_aedp/services/grades/grade_service.dart';
import 'package:project_aedp/utils/grades/grade_utils.dart';
import 'package:project_aedp/widget/input_grade_widget/student_info_card.dart';
import 'package:project_aedp/widget/input_grade_widget/subjects_list.dart';
import 'package:project_aedp/widget/input_grade_widget/submit_button.dart';


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
  late TabController _tabController;
  late final GradeService _gradeService;
  late final GradeUtils _gradeUtils;
  
  // Controllers for all periods
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
  bool _isLoading = false;
  late final String _currentDate;
  late final int _coefficient;
  late final int _periodCount;
  late final bool _isPrimaryLevel;
  late final bool _isSecondaryLevel;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeGradeLevel();
    _initializeTabController();
    _currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _fetchSubjectsAndExistingGrades();
  }

  void _initializeServices() {
    _gradeService = GradeService();
    _gradeUtils = GradeUtils();
  }

  void _initializeGradeLevel() {
    final gradeLevel = _gradeUtils.determineGradeLevel(widget.gradeClass);
    _isPrimaryLevel = gradeLevel.isPrimary;
    _isSecondaryLevel = gradeLevel.isSecondary;
    _coefficient = gradeLevel.coefficient;
    _periodCount = gradeLevel.periodCount;
  }

  void _initializeTabController() {
    _tabController = TabController(length: _periodCount, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    
    setState(() {
      _selectedExamType = _gradeUtils.getExamType(_tabController.index);
      _fetchSubjectsAndExistingGrades();
    });
  }

  @override
  void dispose() {
    _disposeControllers();
    _tabController.dispose();
    super.dispose();
  }

  void _disposeControllers() {
    _controllersByExamType.forEach((examType, controllers) {
      controllers.forEach((_, controller) => controller.dispose());
    });
  }

  Future<void> _fetchSubjectsAndExistingGrades() async {
    setState(() => _isLoading = true);
    
    try {
      final result = await _gradeService.fetchSubjectsAndGrades(
        gradeClass: widget.gradeClass,
        schoolId: widget.schoolId,
        examType: _selectedExamType,
      );
      
      _updateControllersAndData(result);
    } catch (e) {
      _showErrorMessage('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateControllersAndData(
    GradeDataResult result) {
    // Ensure controllers exist for current exam type
    if (!_controllersByExamType.containsKey(_selectedExamType)) {
      _controllersByExamType[_selectedExamType] = {};
    }
    
    // Create controllers for subjects
    for (var subject in result.subjects) {
      if (!_controllersByExamType[_selectedExamType]!.containsKey(subject.id)) {
        _controllersByExamType[_selectedExamType]![subject.id] = TextEditingController();
      }
      
      // Set existing grade if available
      if (result.existingGrades.containsKey(subject.id)) {
        _controllersByExamType[_selectedExamType]![subject.id]!.text = 
            result.existingGrades[subject.id]!;
      }
    }
    
    setState(() {
      _subjectNames.clear();
      _subjectNames.addAll(result.subjectNames);
      _existingGradeIdsByExamType[_selectedExamType] = result.existingGradeIds;
      _existingGradesByExamType[_selectedExamType] = result.existingGrades;
    });
  }

  Future<void> _submitGrades() async {
    setState(() => _isLoading = true);
    
    try {
      final currentControllers = _controllersByExamType[_selectedExamType] ?? {};
      final currentExistingGradeIds = _existingGradeIdsByExamType[_selectedExamType] ?? {};

      // Validate grades first
      final validationError = _validateGrades(currentControllers);
      if (validationError != null) {
        _showErrorMessage(validationError);
        return;
      }

      // Submit grades
      await _gradeService.submitGrades(
        controllers: currentControllers,
        existingGradeIds: currentExistingGradeIds,
        subjectNames: _subjectNames,
        gradeData: GradeSubmissionData(
          schoolId: widget.schoolId,
          studentName: widget.studentName,
          gradeClass: widget.gradeClass,
          coefficient: _coefficient,
          currentDate: _currentDate,
          examType: _selectedExamType,
        ),
      );

      _showSuccessMessage();
      Navigator.pop(context);
    } catch (e) {
      _showErrorMessage('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateGrades(Map<String, TextEditingController> controllers) {
    for (var entry in controllers.entries) {
      final gradeValue = entry.value.text;
      if (gradeValue.isNotEmpty) {
        final grade = int.tryParse(gradeValue);
        if (grade == null || grade < 0 || grade > 20) {
          return S.of(context).gradeValidation + ' (0-20)';
        }
      }
    }
    return null;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).gradesUploaded),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        '${S.of(context).grade}: ${widget.studentName}',
        style: const TextStyle(color: Colors.white),
      ),
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
    );
  }

  Widget _buildBody() {
    return Container(
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
              child: TabBarView(
                controller: _tabController,
                children: List.generate(_periodCount, (index) => _buildTabContent()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StudentInfoCard(
                  studentName: widget.studentName,
                  schoolId: widget.schoolId,
                  gradeClass: widget.gradeClass,
                  currentDate: _currentDate,
                ),
                const SizedBox(height: 16),
                _buildGradeSection(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SubmitButton(
          onPressed: _isLoading ? null : _submitGrades,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  Widget _buildGradeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3F51B5)),
                ),
              )
            : SubjectsList(
                controllers: _controllersByExamType[_selectedExamType] ?? {},
                subjectNames: _subjectNames,
                existingGrades: _existingGradesByExamType[_selectedExamType] ?? {},
              ),
      ],
    );
  }

  List<Widget> _buildPeriodTabs() {
    final List<Widget> tabs = [
      Tab(text: S.of(context).firstPeriod),
      Tab(text: S.of(context).secondPeriod),
    ];
    
    if (_isPrimaryLevel) {
      tabs.add(Tab(text: S.of(context).thirdPeriod));
    }
    
    return tabs;
  }
}