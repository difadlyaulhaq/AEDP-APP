import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/bloc/material_and_subject/material_event.dart';
import 'package:project_aedp/bloc/material_and_subject/material_state.dart' as custom;
import 'package:project_aedp/bloc/material_and_subject/teacher_bloc.dart';
import 'package:project_aedp/generated/l10n.dart';
import '../../../widget/teacher_material/material_card.dart';
import '../../../widget/teacher_material/material_shimmer.dart';


class TeacherMaterialPage extends StatefulWidget {
  final List<String> teacherClasses;
  const TeacherMaterialPage({super.key, required this.teacherClasses});

  @override
  State<TeacherMaterialPage> createState() => _TeacherMaterialPageState();
}

class _TeacherMaterialPageState extends State<TeacherMaterialPage> {
  void _fetchSubjects() {
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
  void initState() {
    super.initState();
    _fetchSubjects();
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
            return MaterialShimmer(screenWidth: screenWidth, screenHeight: screenHeight);
          } else if (state is custom.SubjectsLoaded) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: ListView.builder(
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
                  return MaterialCard(
                    subject: state.subjects[index],
                    onRefresh: _fetchSubjects,
                  );
                },
              ),
            );
          } else if (state is custom.MaterialError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchSubjects,
                    child: Text("retry".toUpperCase(),
                  ),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('No subjects available'));
        },
      ),
    );
  }
}
