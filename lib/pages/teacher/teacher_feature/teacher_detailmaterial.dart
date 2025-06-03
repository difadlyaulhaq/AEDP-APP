// teacher_detail_material.dart
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/bloc/material_and_subject/material_event.dart';
import 'package:project_aedp/bloc/material_and_subject/teacher_bloc.dart';
import 'package:project_aedp/widget/teacher_detail_material_widget/material_app_bar.dart';
import 'package:project_aedp/widget/teacher_detail_material_widget/upload_material_dialog.dart';

import '../../../widget/teacher_detail_material_widget/add_button.dart';
import '../../../widget/teacher_detail_material_widget/material_list.dart';


class TeacherDetailMaterial extends StatefulWidget {
  final String subject;
  final String subjectId;
  final String grade;

  const TeacherDetailMaterial({
    super.key,
    required this.subject,
    required this.subjectId,
    required this.grade,
  });

  @override
  State<TeacherDetailMaterial> createState() => _TeacherDetailMaterialState();
}

class _TeacherDetailMaterialState extends State<TeacherDetailMaterial> {
  late MaterialBloc _materialBloc;
  late LoadProfileBloc _loadprofile;
  
  @override
  void initState() {
    super.initState();
    _initializeBlocs();
  }

  void _initializeBlocs() {
    final selectedLanguage = context.read<LanguageCubit>().state.locale.languageCode;
    _loadprofile = context.read<LoadProfileBloc>();
    final state = _loadprofile.state;
    
    if (state is LoadProfileLoaded) {
      final teacherClasses = _extractTeacherClasses(state.profileData['classes']);
      _materialBloc = MaterialBloc()..add(
        FetchMaterials(
          subjectId: widget.subjectId,
          grade: widget.grade, 
          selectedLanguage: selectedLanguage,
          isTeacher: true, 
          teacherClasses: teacherClasses.join(','),
          studentGradeClass: ''
        )
      );
    } else {
      dev.log('LoadProfileBloc state is not LoadProfileLoaded');
    }
  }

  List<String> _extractTeacherClasses(dynamic teacherClassesRaw) {
    if (teacherClassesRaw is String) {
      return teacherClassesRaw.split(',').map((e) => e.trim()).toList();
    } else if (teacherClassesRaw is List) {
      return teacherClassesRaw.cast<String>();
    }
    return [];
  }

  @override
  void dispose() {
    _materialBloc.close();
    super.dispose();
  }

  void refreshMaterials() {
    final selectedLanguage = context.read<LanguageCubit>().state.locale.languageCode;
    final state = _loadprofile.state;
    
    if (state is LoadProfileLoaded) {
      final teacherClasses = _extractTeacherClasses(state.profileData['classes']);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Refreshing materials...'),
          duration: Duration(seconds: 1),
        ),
      );
      
      _materialBloc.add(
        FetchMaterials(
          subjectId: widget.subjectId,
          grade: widget.grade,
          selectedLanguage: selectedLanguage,
          isTeacher: true,
          teacherClasses: teacherClasses.join(','),
          studentGradeClass: ''
        )
      );
    }
  }

  void showUploadDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => UploadMaterialDialog(
        materialBloc: _materialBloc,
        subjectId: widget.subjectId,
        onUploadComplete: () {
          Navigator.pop(dialogContext);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploading material...'),
              duration: Duration(seconds: 2),
            ),
          );
          Future.delayed(const Duration(seconds: 2), refreshMaterials);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _materialBloc,
      child: Scaffold(
        appBar: MaterialAppBar(
          subject: widget.subject,
          onRefresh: refreshMaterials,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AddMaterialButton(onPressed: showUploadDialog),
              const SizedBox(height: 16.0),
              MaterialListWidget(materialBloc: _materialBloc),
            ],
          ),
        ),
      ),
    );
  }
}