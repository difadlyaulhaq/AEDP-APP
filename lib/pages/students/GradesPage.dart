// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:project_aedp/theme/theme.dart';

class Gradespage extends StatefulWidget {
  const Gradespage({super.key});

  @override
  State<Gradespage> createState() => _GradespageState();
}

class _GradespageState extends State<Gradespage> {
  String selectedYear = '2024';
  String selectedSemester = 'Odd';

  List<Map<String, dynamic>> gradesData = [
    {"subject": "Mathematics", "grade": 82, "year": "2024", "semester": "Odd"},
    {"subject": "Science", "grade": 91, "year": "2024", "semester": "Even"},
    {"subject": "History", "grade": 100, "year": "2024", "semester": "Odd"},
    {"subject": "Physical Education", "grade": 80, "year": "2024", "semester": "Even"},
    {"subject": "Art", "grade": 19, "year": "2024", "semester": "Odd"},
    {"subject": "English", "grade": 100, "year": "2024", "semester": "Even"},
    {"subject": "Arabic", "grade": 100, "year": "2024", "semester": "Odd"},
  ];

  List<Map<String, dynamic>> get filteredGrades {
    return gradesData
        .where((grade) =>
            grade["year"] == selectedYear && grade["semester"] == selectedSemester)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double gpa = _calculateGPA(filteredGrades);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: ClipPath(
          clipper: CustomAppBarClipper(),
          child: AppBar(
            automaticallyImplyLeading: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(30, 113, 162, 1),
                    Color.fromRGBO(11, 42, 60, 1),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/student_home'),
            ),
            title: Text(
              'Your Grades',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.05, // Adjust size dynamically
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: screenHeight * 0.1,
                width: screenHeight * 0.1,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E70A0),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  gpa.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "List of Subjects",
                  style: blackColorTextStyle.copyWith(
                    fontSize: screenWidth * 0.045,
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
                    SizedBox(width: screenWidth * 0.02),
                    DropdownButton<String>(
                      value: selectedSemester,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSemester = newValue!;
                        });
                      },
                      items: ['Odd', 'Even']
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
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: filteredGrades.length,
                itemBuilder: (context, index) {
                  var gradeItem = filteredGrades[index];
                  return _buildGradeItem(
                    gradeItem["subject"],
                    gradeItem["grade"].toString(),
                    screenWidth,
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

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(0, size.height, 40, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
