import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/material_and_subject/material_model.dart';
import 'package:project_aedp/bloc/material_and_subject/material_event.dart';
import 'package:project_aedp/bloc/material_and_subject/material_state.dart' as teacher_material_state;
import 'package:project_aedp/bloc/material_and_subject/teacher_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _materialBloc = MaterialBloc()..add(FetchMaterials(subjectId: widget.subjectId));
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

  void _showUploadDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    File? selectedFile;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Upload Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 10),
            TextField(controller: descriptionController, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                if (result != null) {
                  setState(() {
                    selectedFile = File(result.files.single.path!);
                  });
                }
              },
              child: const Text('Select PDF File'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (selectedFile != null) {
                _handleMaterialUpload(dialogContext, titleController.text, descriptionController.text, selectedFile!);
              } else {
                _showErrorSnackBar(dialogContext, 'Please select a PDF file.');
              }
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _handleMaterialUpload(BuildContext context, String title, String description, File file) {
    if (title.isEmpty || description.isEmpty) {
      _showErrorSnackBar(context, 'Please fill all fields');
      return;
    }
    final material = MaterialModel(
      id: DateTime.now().toIso8601String(),
      title: title,
      description: description,
      fileLink: '',
      grade: widget.grade,
      subjectId: widget.subjectId,
    );
    _materialBloc.add(AddMaterial(material: material, file: file));
    Navigator.pop(context);
    _materialBloc.add(FetchMaterials(subjectId: widget.subjectId));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Material uploaded successfully!')));
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
