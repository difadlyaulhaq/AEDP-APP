import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:project_aedp/bloc/certificates_download/certificates_download_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:http/http.dart' as http;

import '../../bloc/certificates_download/certificate_item.dart';

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final profileBloc = context.read<LoadProfileBloc>();
        final state = profileBloc.state;
        String fatherName = 'Father Name'; // Default value

        if (state is LoadProfileLoaded &&
            state.profileData['role'] == 'parent') {
          fatherName = state.profileData['fullName'] ?? 'Father Name';
        }

        return CertificatesDownloadBloc()..add(LoadCertificates(fatherName));
      },
      child: const CertificateView(),
    );
  }
}

class CertificateView extends StatelessWidget {
  const CertificateView({super.key});

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      // Handle permissions for Android 13 and above
      if (await Permission.photos.request().isGranted &&
          await Permission.videos.request().isGranted &&
          await Permission.audio.request().isGranted) {
        return true;
      }
      // Handle permissions for Android 12 and below
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      // Handle permanently denied permissions
      if (await Permission.storage.isPermanentlyDenied) {
        final bool shouldOpenSettings = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Storage Permission Required'),
                content: const Text(
                  'This permission is required to download and save certificates. Please enable it in settings.',
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
            ) ??
            false;

        if (shouldOpenSettings) {
          await openAppSettings();
        }
      }
      return false;
    }
    return true;
  }

  Future<String?> _getDownloadPath(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await _requestStoragePermission(context)) {
        Directory? directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return directory.path;
      }
      return null;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  Future<void> _downloadCertificate(
      BuildContext context, CertificateItem item) async {
    try {
      final downloadPath = await _getDownloadPath(context);
      if (downloadPath == null) {
        throw Exception('Storage permission not granted');
      }

      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(item.pdfPath).toString();

      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        final fileName = item.pdfPath.split('/').last;
        final filePath = '$downloadPath/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to $filePath')),
        );
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).certificates),
      ),
      body: BlocConsumer<CertificatesDownloadBloc, CertificatesDownloadState>(
        listener: (context, state) {
          if (state is CertificatesDownloadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CertificatesLoading ||
              state is CertificatesDownloading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CertificatesLoaded) {
            if (state.certificates.isEmpty) {
              return Center(child: Text(S.of(context).noFilesAvailable));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.certificates.length,
              itemBuilder: (context, index) {
                final item = state.certificates[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.subtitle),
                    trailing: IconButton(
                      icon: const Icon(Icons.file_download),
                      onPressed: () => _downloadCertificate(context, item),
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: Text(S.of(context).loadingLabel));
        },
      ),
    );
  }
}
