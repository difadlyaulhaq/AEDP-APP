import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassCard extends StatefulWidget {
  final Map<String, dynamic> classInfo;

  const ClassCard({super.key, required this.classInfo});

  @override
  State<ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  bool _isDownloading = false;

  Future<void> _downloadAndOpenSchedule(String pdfPath) async {
    setState(() => _isDownloading = true);
    final baseUrl = "https://gold-tiger-632820.hostingersite.com/";
    final downloadUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();

    try {
      final uri = Uri.parse(downloadUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $downloadUrl';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open URL: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final classInfo = widget.classInfo;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classInfo['subject'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Grade: ${classInfo['class']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (classInfo['pdf_path'] != null)
              _isDownloading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: () => _downloadAndOpenSchedule(classInfo['pdf_path']),
                      icon: const Icon(Icons.download),
                      label: const Text('Download Schedule'),
                    ),
          ],
        ),
      ),
    );
  }
}
