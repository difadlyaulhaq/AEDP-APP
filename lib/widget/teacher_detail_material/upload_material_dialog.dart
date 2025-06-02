// widgets/upload_material_dialog.dart
import 'dart:developer' as dev;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_aedp/bloc/material_and_subject/material_model.dart';
import 'package:project_aedp/bloc/material_and_subject/material_event.dart';
import 'package:project_aedp/bloc/material_and_subject/teacher_bloc.dart';

import 'file_picker_widget.dart';
import 'grade_dropdown_widget.dart';

class UploadMaterialDialog extends StatefulWidget {
  final MaterialBloc materialBloc;
  final String subjectId;
  final VoidCallback onUploadComplete;

  const UploadMaterialDialog({
    super.key,
    required this.materialBloc,
    required this.subjectId,
    required this.onUploadComplete,
  });

  @override
  State<UploadMaterialDialog> createState() => _UploadMaterialDialogState();
}

class _UploadMaterialDialogState extends State<UploadMaterialDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedFile;
  String? _selectedGrade;
  bool _isUploading = false;
  List<String> _availableGrades = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableGrades();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableGrades() async {
    try {
      final grades = await widget.materialBloc.fetchGradesForSubject(widget.subjectId);
      if (mounted) {
        setState(() {
          _availableGrades = grades;
        });
        
        if (grades.isEmpty) {
          _showErrorSnackBar('No grades available for this subject.');
          Navigator.pop(context);
        }
      }
    } catch (e) {
      dev.log("Failed to fetch grades: $e");
      if (mounted) {
        _showErrorSnackBar('Failed to load class options.');
        Navigator.pop(context);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    
    if (result != null && mounted) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _handleUpload() async {
    if (!_validateForm()) return;

    setState(() => _isUploading = true);
    
    try {
      final material = MaterialModel(
        id: DateTime.now().toIso8601String(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        fileLink: '',
        grade: _selectedGrade!,
        subjectId: widget.subjectId,
      );
      
      widget.materialBloc.add(
        AddMaterial(
          material: material,
          file: _selectedFile!,
          grade: _selectedGrade!,
        ),
      );
      
      widget.onUploadComplete();
    } catch (e) {
      _showErrorSnackBar('Upload failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  bool _validateForm() {
    if (_selectedFile == null || 
        _selectedGrade == null || 
        _titleController.text.trim().isEmpty) {
      _showErrorSnackBar('Please fill all required fields (*)');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.upload_file, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          const Text(
            'Upload Material',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradeDropdownWidget(
              availableGrades: _availableGrades,
              selectedGrade: _selectedGrade,
              isEnabled: !_isUploading,
              onChanged: (value) => setState(() => _selectedGrade = value),
            ),
            const SizedBox(height: 16),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            FilePickerWidget(
              selectedFile: _selectedFile,
              isEnabled: !_isUploading,
              onFilePicked: _handleFileSelection,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUploading ? null : () => Navigator.pop(context),
          child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isUploading ? null : _handleUpload,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isUploading
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
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      enabled: !_isUploading,
      decoration: InputDecoration(
        labelText: 'Material Title*',
        prefixIcon: Icon(Icons.title, color: Theme.of(context).primaryColor),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      enabled: !_isUploading,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Description',
        prefixIcon: Icon(Icons.description, color: Theme.of(context).primaryColor),
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }
}