import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/theme/theme.dart';

class ParentGradesPage extends StatefulWidget {
  const ParentGradesPage({super.key});

  @override
  State<ParentGradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<ParentGradesPage> {
  String selectedYear = '2024';
  String selectedSemester = 'Odd';

  List<Map<String, dynamic>> getGradesData(BuildContext context) {
    return [
      {"subject": S.of(context).subject_math, "grade": 82, "year": "2024", "semester": "Odd"},
      {"subject": S.of(context).subject_science, "grade": 91, "year": "2024", "semester": "Even"},
      {"subject": S.of(context).subject_history, "grade": 100, "year": "2024", "semester": "Odd"},
      {"subject": S.of(context).subject_physical_education, "grade": 80, "year": "2024", "semester": "Even"},
      {"subject": S.of(context).subject_art, "grade": 19, "year": "2024", "semester": "Odd"},
      {"subject": S.of(context).subject_english, "grade": 100, "year": "2024", "semester": "Even"},
      {"subject": S.of(context).subject_arabic, "grade": 100, "year": "2024", "semester": "Odd"},
    ];
  }

  List<Map<String, dynamic>> getFilteredGrades(List<Map<String, dynamic>> gradesData) {
    return gradesData.where((grade) {
      return grade['year'] == selectedYear && grade['semester'] == selectedSemester;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final gradesData = getGradesData(context);
    final filteredGrades = getFilteredGrades(gradesData);
    double gpa = _calculateGPA(filteredGrades);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).grades_title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E71A2), Color(0xFF0B2A3C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.height * 0.1,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E70A0),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  gpa.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).subject_list_title,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    color: const Color.fromRGBO(13, 49, 70, 1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: selectedYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue!;
                        });
                      },
                      items: ['2024', '2023', '2022']
                          .map((year) => DropdownMenuItem<String>(
                                value: year,
                                child: Text(year),
                              ))
                          .toList(),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    DropdownButton<String>(
                      value: selectedSemester,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSemester = newValue!;
                        });
                      },
                      items: [S.of(context).semester_odd, S.of(context).semester_even]
                          .map((semester) => DropdownMenuItem<String>(
                                value: semester,
                                child: Text(semester),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: filteredGrades.length,
                itemBuilder: (context, index) {
                  var gradeItem = filteredGrades[index];
                  return _buildGradeItem(
                    gradeItem["subject"],
                    gradeItem["grade"].toString(),
                    MediaQuery.of(context).size.width,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateGPA(List<Map<String, dynamic>> grades) {
    if (grades.isEmpty) return 0.0;
    double total = grades.fold(0, (sum, item) => sum + item["grade"]);
    return total / grades.length;
  }

  Widget _buildGradeItem(String subject, String grade, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D3146),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(screenWidth * 0.02),
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.white,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E70A0),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Text(
              grade,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}