import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/material_and_subject/material_model.dart';
import '../../bloc/material_and_subject/material_event.dart';
import '../../bloc/material_and_subject/material_state.dart' as teacher_material_state;
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/material_and_subject/teacher_bloc.dart';

class TeacherDetailMaterial extends StatefulWidget {
  final String subject;
  final String subjectId;
  final String grade; // Tambahkan grade untuk upload material

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
    _materialBloc = MaterialBloc();
    _materialBloc.add(FetchMaterials(subjectId: widget.subjectId));
  }

  @override
  void dispose() {
    _materialBloc.close();
    super.dispose();
  }

  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.isAbsolute && uri.hasScheme;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider.value(
      value: _materialBloc,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.15),
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
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '${widget.subject} Materials',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
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
        icon: const Icon(
          Icons.add_circle,
          color: Color.fromRGBO(30, 113, 162, 1),
          size: 32,
        ),
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
          } 
          else if (state is teacher_material_state.MaterialLoaded) {
        return ListView.builder(
              itemCount: state.materials.length,
              itemBuilder: (context, index) {
                final material = state.materials[index];
                return _buildMaterialCard(
                  context,
                  material.title,
                  material.description,
                  material.fileLink,
                );
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

  Widget _buildMaterialCard(
    BuildContext context,
    String title,
    String description,
    String fileLink,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _openFile(context, fileLink),
              child: Text(
                'Open Material',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFile(BuildContext context, String url) async {
    try {
      final Uri? uri = Uri.tryParse(url);
      if (uri == null) {
        throw Exception('Invalid URL format');
      }

      if (uri.scheme == 'http' || uri.scheme == 'https') {
        final bool canLaunch = await canLaunchUrl(uri);
        if (canLaunch) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
            webViewConfiguration: const WebViewConfiguration(
              enableJavaScript: true,
              enableDomStorage: true,
            ),
          );
        } else {
          throw Exception('Could not launch URL');
        }
      } else {
        throw Exception('Unsupported URL scheme');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open URL: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                if (result != null) {
                  selectedFile = File(result.files.single.path!);
                }
              },
              child: const Text('Select PDF File'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedFile != null) {
              _handleMaterialUpload(
                dialogContext,
                titleController.text.trim(),
                descriptionController.text.trim(),
                selectedFile!,
              );
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
    fileLink: '', // Nanti akan diperbarui setelah upload
    grade: widget.grade,
    subjectId: widget.subjectId,
    createdAt: DateTime.now(),
  );

  context.read<MaterialBloc>().add(AddMaterial(material: material, file: file));
  Navigator.pop(context);
  Future.delayed(Duration(milliseconds: 300), () {
    _materialBloc.add(FetchMaterials(subjectId: widget.subjectId));
  });  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Material uploaded successfully!')),
  );
}

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomAppBarClipper oldClipper) {
    return false;
  }
}