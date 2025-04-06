import 'dart:developer' as dev;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/bloc/material_and_subject/material_model.dart';
import 'package:project_aedp/bloc/material_and_subject/material_event.dart';
import 'package:project_aedp/bloc/material_and_subject/material_state.dart' as teacher_material_state;
import 'package:project_aedp/bloc/material_and_subject/teacher_bloc.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';


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
  String? selectedGrade;
  
  @override
  void initState() {
    super.initState();
    final selectedLanguage = context.read<LanguageCubit>().state.locale.languageCode;
    // Ensure teacherClasses is not null and is explicitly typed as List<String>
    _loadprofile = context.read<LoadProfileBloc>();
    final state = _loadprofile.state;
    if (state is LoadProfileLoaded) {
      // Ensure teacherClasses is not null and is explicitly typed as List<String>
      final teacherClassesRaw = state.profileData['classes'];
      final List<String> teacherClasses = teacherClassesRaw is String
          ? teacherClassesRaw.split(',').map((e) => e.trim()).toList()
          : (teacherClassesRaw is List)
              ? teacherClassesRaw.cast<String>() // Cast to List<String>
              : [];
            
        _materialBloc = MaterialBloc()..add(
      FetchMaterials(subjectId: widget.subjectId,
       grade: widget.grade, 
       selectedLanguage: selectedLanguage,
        isTeacher: true, 
            teacherClasses:
            teacherClasses.join(','), // Join the list into a string
         studentGradeClass: ''));

    } else {
      dev.log('LoadProfileBloc state is not LoadProfileLoaded');
    }
  }

  @override
  void dispose() {
    _materialBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _materialBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.subject} Materials',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(30, 113, 162, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildAddButton(context),
              const SizedBox(height: 16.0),
              _buildMaterialsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(Icons.add_circle, color: Color.fromRGBO(30, 113, 162, 1), size: 32),
        onPressed: () => _showUploadDialog(context),
      ),
    );
  }

  Widget _buildMaterialsList() {
    return Expanded(
      child: BlocBuilder<MaterialBloc, teacher_material_state.MaterialState>(
        builder: (context, state) {
          if (state is teacher_material_state.MaterialLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is teacher_material_state.MaterialLoaded) {
            return ListView.builder(
              itemCount: state.materials.length,
              itemBuilder: (context, index) {
                final material = state.materials[index];
                return _buildMaterialCard(material);
              },
            );
          } else if (state is teacher_material_state.MaterialError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          return const Center(child: Text('No materials available.'));
        },
      ),
    );
  }

  Widget _buildMaterialCard(MaterialModel material) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(material.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(material.description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new, color: Colors.blue),
          onPressed: () => _openFile(material.fileLink),
        ),
      ),
    );
  }

  Future<void> _openFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open file.')),
      );
    }
  }

  void _showUploadDialog(BuildContext context) async {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? selectedFile;
  String? selectedGrade;
  bool isUploading = false;
  List<String> availableGrades = [];

  try {
    availableGrades = await _materialBloc.fetchGradesForSubject(widget.subjectId);
    if (availableGrades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No grades available for this subject.')),
      );
      return;
    }
  } catch (e) {
    dev.log("Failed to fetch grades: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load class options.')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.upload_file, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              const Text('Upload Material', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grade Selection
                DropdownButtonFormField<String>(
                  value: selectedGrade,
                  decoration: InputDecoration(
                    labelText: 'Class Grade*',
                    prefixIcon: Icon(Icons.school, color: Theme.of(context).primaryColor),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  items: availableGrades.map((grade) {
                    return DropdownMenuItem<String>(
                      value: grade,
                      child: Text('${S.of(context).classes} : $grade'),
                    );
                  }).toList(),
                  onChanged: isUploading
                      ? null
                      : (value) => setState(() => selectedGrade = value),
                ),
                const SizedBox(height: 16),

                // Title Input
                TextField(
                  controller: titleController,
                  enabled: !isUploading,
                  decoration: InputDecoration(
                    labelText: 'Material Title*',
                    prefixIcon: Icon(Icons.title, color: Theme.of(context).primaryColor),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Description Input
                TextField(
                  controller: descriptionController,
                  enabled: !isUploading,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description, color: Theme.of(context).primaryColor),
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 16),

                // File Upload Section
                OutlinedButton(
                  onPressed: isUploading
                      ? null
                      : () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );
                          if (result != null) {
                            setState(() {
                              selectedFile = File(result.files.single.path!);
                            });
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_file, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Select PDF File',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Selected File Preview
                if (selectedFile != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedFile!.path.split('/').last,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade800,
                                ),
                              ),
                              Text(
                                '${(selectedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isUploading ? null : () => Navigator.pop(dialogContext),
              child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: isUploading
                  ? null
                  : () async {
                      if (selectedFile == null || selectedGrade == null || titleController.text.isEmpty) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields (*)'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setState(() => isUploading = true);
                      
                      try {
                        _handleMaterialUpload(
                          dialogContext,
                          titleController.text,
                          descriptionController.text,
                          selectedFile!,
                          selectedGrade!,
                        );
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('Upload successful!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Upload failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        setState(() => isUploading = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('UPLOAD', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ),
  );
}

  void _handleMaterialUpload(BuildContext context, String title, String description, File file, String grade) {
    final selectedLanguage = context.read<LanguageCubit>().state.locale.languageCode;
    final state = _loadprofile.state;
    List<String> teacherClasses = [];
    if (state is LoadProfileLoaded) {
      final teacherClassesRaw = state.profileData['classes'];
      teacherClasses = teacherClassesRaw is String
          ? teacherClassesRaw.split(',').map((e) => e.trim()).toList()
          : (teacherClassesRaw is List)
              ? teacherClassesRaw.cast<String>()
              : [];
    }
    final material = MaterialModel(
      id: DateTime.now().toIso8601String(),
      title: title,
      description: description,
      fileLink: '',
      grade: grade,
      subjectId: widget.subjectId,
    );
    _materialBloc.add(AddMaterial(material: material, file: file, grade: grade));
    Navigator.pop(context);
    _materialBloc.add(
      FetchMaterials(subjectId: widget.subjectId,
       grade: widget.grade, 
       selectedLanguage: selectedLanguage,
        isTeacher: true, 
            teacherClasses:
            teacherClasses.join(','), // Join the list into a string
         studentGradeClass: ''
         ));
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}