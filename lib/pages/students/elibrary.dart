import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_aedp/generated/l10n.dart';
import '../../bloc/library_download/library_download_bloc.dart';
import '../../bloc/library_download/library_download_state.dart';
import '../../bloc/library_download/library_download_event.dart';

class ELibraryPage extends StatefulWidget {
  const ELibraryPage({super.key});

  @override
  _ELibraryPageState createState() => _ELibraryPageState();
}

class _ELibraryPageState extends State<ELibraryPage> {
  bool isDownloading = false;

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted &&
          await Permission.videos.request().isGranted &&
          await Permission.audio.request().isGranted) {
        return true;
      }
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      if (await Permission.storage.isPermanentlyDenied) {
        final bool shouldOpenSettings = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Storage Permission Required'),
                content: const Text(
                    'This permission is required to download and save files. Please enable it in settings.'),
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

  Future<String?> _getDownloadPath() async {
    if (Platform.isAndroid) {
      Directory? directory;
      if (await _requestStoragePermission()) {
        directory = Directory('/storage/emulated/0/Download');
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

  Future<void> _downloadAndOpenFile(String filePath) async {
    try {
      setState(() => isDownloading = true);

      final downloadPath = await _getDownloadPath();
      if (downloadPath == null) {
        throw Exception('Storage permission not granted');
      }

      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(filePath).toString();

      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        final fileName = filePath.split('/').last;
        final file = File('$downloadPath/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(file.path);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to ${file.path}')),
        );
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
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
        title: Text(S.of(context).appTitle),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E71A2),
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = LibraryDownloadBloc();
          bloc.add(LoadLibraryFiles());
          return bloc;
        },
        child: BlocBuilder<LibraryDownloadBloc, LibraryDownloadState>(
          builder: (context, state) {
            if (state is LibraryDownloadLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LibraryDownloadError) {
              return Center(
                  child: Text(
                S.of(context).errorLabel(state.message),
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ));
            }

            if (state is LibraryDownloadLoaded) {
              if (state.files.isEmpty) {
                return Center(
                  child: Text(
                    S.of(context).noFilesAvailable,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(top: 16.0), // Jarak dari AppBar
                child: ListView.builder(
                  itemCount: state.files.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final file = state.files[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0), // Jarak antar Card
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: const Icon(Icons.file_present,
                              color: Colors.deepPurple),
                          title: Text(
                            file.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          trailing: isDownloading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.download,
                                      color: Colors.green),
                                  onPressed: () =>
                                      _downloadAndOpenFile(file.filePath),
                                ),
                        ),
                      ),
                    );
                  },
                ),
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
      ),
    );
  }
}
