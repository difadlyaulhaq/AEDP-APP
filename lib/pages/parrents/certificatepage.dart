import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aedp/generated/l10n.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  bool isDownloading = false;
Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13 and above (SDK 33+)
      if (await Permission.photos.request().isGranted &&
          await Permission.videos.request().isGranted &&
          await Permission.audio.request().isGranted) {
        return true;
      }
      // For Android 12 and below
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      
      // Show rationale if permission denied
      if (await Permission.storage.isPermanentlyDenied) {
        // Show dialog explaining why permission is needed
        final bool shouldOpenSettings = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Storage Permission Required'),
            content: const Text(
              'This permission is required to download and save invoices. Please enable it in settings.'
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ?? false;

        if (shouldOpenSettings) {
          await openAppSettings();
        }
      }
      return false;
    }
    
    // For iOS, we use getApplicationDocumentsDirectory() so no explicit permission needed
    return true;
  }

    Future<String?> _getDownloadPath() async {
    if (Platform.isAndroid) {
      // For Android, use the Downloads directory
      Directory? directory;
      if (await _requestStoragePermission()) {
        directory = Directory('/storage/emulated/0/Download');
        // Create directory if it doesn't exist
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return directory.path;
      }
      return null;
    } else {
      // For iOS, use the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  Future<void> _downloadAndOpenPDF(String pdfPath) async {
    try {
      setState(() => isDownloading = true);

      final downloadPath = await _getDownloadPath();
      if (downloadPath == null) {
        throw Exception('Storage permission not granted');
      }

      // Step 1: Combine base URL with relative path
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();

      // Step 2: Download PDF from URL
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        // Step 3: Save the file locally
        final fileName = pdfPath.split('/').last;
        final filePath = '$downloadPath/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Step 4: Open the PDF file
        await OpenFile.open(filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to $filePath')),
        );
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => isDownloading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).certificates_and_reports),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('certificates').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(S.of(context).noFilesAvailable));
          }

          final items = snapshot.data!.docs.map((doc) {
            final fatherName = doc['father_name'] ?? S.of(context).fatherName;
            final fileName = doc['file_name'] ?? "Unknown File";
            final pdfPath = doc['pdf_path'] ?? '';
            return CertificateItem(fatherName, fileName, pdfPath);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return buildCertificateItem(context, item);
            },
          );
        },
      ),
    );
  }

  Widget buildCertificateItem(BuildContext context, CertificateItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(item.title),
        subtitle: Text(item.subtitle),
        trailing: isDownloading
            ? const CircularProgressIndicator()
            : IconButton(
                icon: const Icon(Icons.file_download),
                onPressed: () => _downloadAndOpenPDF(item.pdfPath),
              ),
      ),
    );
  }
}

class CertificateItem {
  final String title;
  final String subtitle;
  final String pdfPath;

  CertificateItem(this.title, this.subtitle, this.pdfPath);
}
