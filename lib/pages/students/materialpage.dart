import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/material_and_subject/material_event.dart';
import 'package:project_aedp/bloc/material_and_subject/material_state.dart' as custom;
import 'package:project_aedp/bloc/material_and_subject/subject_model.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/students/detailmaterial.dart';
import '../../bloc/material_and_subject/teacher_bloc.dart';

class StudentMaterialPage extends StatefulWidget {
  final String studentGradeClass;

  const StudentMaterialPage({super.key, required this.studentGradeClass});

  @override
  State<StudentMaterialPage> createState() => _StudentMaterialPageState();
}

class _StudentMaterialPageState extends State<StudentMaterialPage> {
  // String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    // print("Fetching subjects for studentGradeClass: '${widget.studentGradeClass}'");

    context.read<MaterialBloc>().add(
      FetchSubjects(
        isTeacher: false,
        teacherClasses: '',
        studentGradeClass: widget.studentGradeClass,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.2),
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
                    Color(0xFF1E70A0),
                    Color(0xFF0B2A3C),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              S.of(context).subjectsTitle,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.065,
              ),
            ),
            centerTitle: true,
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
            //     onPressed: _showFilterDialog,
            //   ),
            // ],
          ),
        ),
      ),
      body: BlocBuilder<MaterialBloc, custom.MaterialState>(
        builder: (context, state) {
          if (state is custom.MaterialLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is custom.SubjectsLoaded) {
            final subjects = state.subjects;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  crossAxisSpacing: screenWidth * 0.04,
                  mainAxisSpacing: screenHeight * 0.02,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return _buildCardItem(context, subject);
                },
              ),
            );
          } else if (state is custom.MaterialError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          return const Center(child: Text('No subjects available'));
        },
      ),
    );
  }

  // void _showFilterDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(S.of(context).filterSubjects),
  //         content: BlocBuilder<MaterialBloc, custom.MaterialState>(
  //           builder: (context, state) {
  //             if (state is custom.SubjectsLoaded) {
  //               final subjects = state.subjects;
  //               final subjectNames = ['All', ...subjects.map((s) => s.subjectName)];

  //               return DropdownButton<String>(
  //                 value: selectedFilter,
  //                 items: subjectNames.map<DropdownMenuItem<String>>((String value) {
  //                   return DropdownMenuItem<String>(
  //                     value: value,
  //                     child: Text(value),
  //                   );
  //                 }).toList(),
  //                 onChanged: (value) {
  //                   setState(() {
  //                     selectedFilter = value!;
  //                     // Implement filtering logic here if needed
  //                   });
  //                   Navigator.pop(context);
  //                 },
  //               );
  //             }
  //             return const CircularProgressIndicator();
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text(S.of(context).cancel),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildCardItem(BuildContext context, SubjectModel subject) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMaterial(
              subject: subject.subjectName,
              subjectId: subject.id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Center(
            child: Text(
              subject.subjectName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

