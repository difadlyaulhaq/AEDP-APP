import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/transcript_downloads/transcript_downloads_bloc.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:http/http.dart' as http;
import '../../bloc/load_profile/profile_state.dart';
import '../../bloc/transcript_downloads/transcript_item.dart';

class TranscriptPage extends StatelessWidget {
  const TranscriptPage({super.key});

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

        return TranscriptDownloadsBloc()..add(LoadTranscripts(fatherName));
      },
      child: const TranscriptView(),
    );
  }
}

class TranscriptView extends StatelessWidget {
  const TranscriptView({super.key});

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
        Directory directory = Directory('/storage/emulated/0/Download');
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

  Future<void> _downloadTranscript(
      BuildContext context, TranscriptItem item) async {
    try {
      final downloadPath = await _getDownloadPath(context);
      if (downloadPath == null) {
        throw Exception('Storage permission not granted');
      }

      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(item.filePath).toString();

      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        final fileName = item.filePath.split('/').last;
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
        title: Text(S.of(context).transcript),
      ),
      body: BlocConsumer<TranscriptDownloadsBloc, TranscriptDownloadsState>(
        listener: (context, state) {
          if (state is TranscriptDownloadsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TranscriptsLoading || 
          state is TranscriptsDownloading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TranscriptsLoaded ) {
            if (state.transcripts.isEmpty) {
              return Center(
                child: Text(
                  S.of(context).noFilesAvailable,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.transcripts.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final file = state.transcripts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.file_present,
                          color: Colors.deepPurple),
                      title: Text(
                        file.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.download, color: Colors.green),
                        onPressed: () => _downloadTranscript(context, file),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: Text(
              S.of(context).loadingLabel,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
