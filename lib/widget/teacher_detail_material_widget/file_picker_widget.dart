// widgets/file_picker_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';

class FilePickerWidget extends StatelessWidget {
  final File? selectedFile;
  final bool isEnabled;
  final VoidCallback onFilePicked;

  const FilePickerWidget({
    super.key,
    required this.selectedFile,
    required this.isEnabled,
    required this.onFilePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton(
          onPressed: isEnabled ? onFilePicked : null,
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
        if (selectedFile != null) _buildSelectedFilePreview(),
      ],
    );
  }

  Widget _buildSelectedFilePreview() {
    final fileName = selectedFile!.path.split('/').last;
    final fileSizeKB = (selectedFile!.lengthSync() / 1024).toStringAsFixed(2);

    return Container(
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
                  fileName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  '$fileSizeKB KB',
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
    );
  }
}