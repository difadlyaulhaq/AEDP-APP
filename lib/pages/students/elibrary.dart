import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart'; // Import the open_file package
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/library_download/library_download_bloc.dart';
import 'package:project_aedp/bloc/library_download/library_download_event.dart';
import 'package:project_aedp/bloc/library_download/library_download_state.dart';
import 'package:project_aedp/generated/l10n.dart';

class ELibraryPage extends StatefulWidget {
  const ELibraryPage({super.key});

  @override
  _ELibraryPageState createState() => _ELibraryPageState();
}

class _ELibraryPageState extends State<ELibraryPage> {
  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final storagePermissionStatus = await Permission.storage.request();
      if (storagePermissionStatus.isGranted) {
        return true;
      }

      if (await Permission.storage.isDenied || await Permission.mediaLibrary.isDenied) {
        final mediaPermissionStatus = await Permission.mediaLibrary.request();
        if (mediaPermissionStatus.isGranted) {
          return true;
        }
      }

      if (await Permission.storage.isPermanentlyDenied || await Permission.mediaLibrary.isPermanentlyDenied) {
        final bool shouldOpenSettings = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Storage Permission Required'),
            content: const Text(
              'This permission is required to download and save files. Please enable it in settings.',
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

  Future<void> _downloadFile(BuildContext context, String filePath) async {
    try {
      final downloadPath = await _getDownloadPath(context);
      if (downloadPath == null) {
        throw Exception('Storage permission not granted');
      }

      context.read<LibraryDownloadBloc>().add(DownloadFile(filePath));

      await for (final state in context.read<LibraryDownloadBloc>().stream) {
        if (state is LibraryDownloadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded to $downloadPath')),
          );
          // Open the file after downloading
          final file = File('$downloadPath/${filePath.split('/').last}');
          final result = await OpenFile.open(file.path);
          if (result.type != ResultType.done) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to open the file')),
            );
          }
          break;
        } else if (state is LibraryDownloadError) {
          throw Exception(state.message);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthLoginSuccess) {
      return authState.userId.toString();
    } else {
      throw Exception('User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).e_library),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E71A2),
      ),
      body: BlocProvider(
        create: (context) {
          final bloc = LibraryDownloadBloc();
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthLoginSuccess) {
            final userId = authState.userId;
            bloc.add(LoadLibraryFiles(userId.toString()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).errorLabel('user not logged in'))),
            );
          }
          if (authState is AuthLoginSuccess && authState.role.toLowerCase() == 'student') {
            bloc.add(LoadLibraryFiles(authState.userId.toString()));
          } else if (authState is AuthLoginSuccess && authState.role.toLowerCase() == 'teacher') {
            bloc.add(LoadLibraryFiles(authState.userId.toString()));
          } else if (authState is AuthLoginSuccess && authState.role.toLowerCase() == 'parent') {
            bloc.add(LoadLibraryFiles(authState.userId.toString()));
          }else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).errorLabel('user role not found'))),
            );
          }
          return bloc;
        },
        child: BlocConsumer<LibraryDownloadBloc, LibraryDownloadState>(
          listener: (context, state) {
            if (state is LibraryDownloadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is LibraryDownloadLoading) {
              return const Center(child: CircularProgressIndicator());
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListView.builder(
                  itemCount: state.files.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final file = state.files[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.file_present, color: Colors.deepPurple),
                          title: Text(
                            file.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.download, color: Colors.green),
                            onPressed: () => _downloadFile(context, file.filePath),
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
