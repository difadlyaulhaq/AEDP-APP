import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/bloc/material_and_subject/material_event.dart';
import 'package:project_aedp/bloc/material_and_subject/material_state.dart' as custom;
import 'package:project_aedp/bloc/material_and_subject/subject_model.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/teacher/teacher_detailmaterial.dart';
import '../../bloc/material_and_subject/teacher_bloc.dart';

class TeacherMaterialPage extends StatefulWidget {
  final List<String> teacherClasses;
  const TeacherMaterialPage({super.key, required this.teacherClasses});

  @override
  TeacherMaterialPageState createState() => TeacherMaterialPageState();
}

class TeacherMaterialPageState extends State<TeacherMaterialPage> {
  @override
  void initState() {
    super.initState();
    final selectedLanguage = context.read<LanguageCubit>().state.locale.languageCode;

    context.read<MaterialBloc>().add(
      FetchSubjects(
        isTeacher: true,
        teacherClasses: widget.teacherClasses.join(','),
        studentGradeClass: '',
        selectedLanguage: selectedLanguage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).subjectsTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.065,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E70A0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<MaterialBloc, custom.MaterialState>(
        builder: (context, state) {
          if (state is custom.MaterialLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is custom.SubjectsLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: ListView.builder(
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
                  return _buildCardItem(context, state.subjects[index]);
                },
              ),
            );
          } else if (state is custom.MaterialError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  ElevatedButton(
                    onPressed: () {
                      final selectedLanguage = context.read<LanguageCubit>().state.locale.languageCode;
                      context.read<MaterialBloc>().add(
                        FetchSubjects(
                          isTeacher: true,
                          teacherClasses: widget.teacherClasses.join(','),
                          studentGradeClass: '',
                          selectedLanguage: selectedLanguage,
                        ),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No subjects available'));
        },
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, SubjectModel subject) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherDetailMaterial(
                subject: subject.subjectName,
                subjectId: subject.id,
                grade: subject.grade,
              ),
            ),
          ).then((_) {
            final selectedLanguage = context.read<LanguageCubit>().state.locale.languageCode;
            context.read<MaterialBloc>().add(
              FetchSubjects(
                isTeacher: true,
                teacherClasses: widget.teacherClasses.join(','),
                studentGradeClass: '',
                selectedLanguage: selectedLanguage,
              ),
            );
          });
        },
      ),
    );
  }
}
