import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/library_download/library_download_bloc.dart';
import 'package:project_aedp/bloc/library_download/library_download_event.dart';
import 'package:project_aedp/bloc/library_download/library_download_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ELibraryPage extends StatefulWidget {
  const ELibraryPage({super.key});

  @override
  _ELibraryPageState createState() => _ELibraryPageState();
}

class _ELibraryPageState extends State<ELibraryPage> {
  bool _isDownloading = false; // save the download state

  Future<void> _downloadFile(String filePath) async {
    setState(() {
      _isDownloading = true; // Menampilkan indikator proses
    });

    try {
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(filePath).toString();

      if (await canLaunchUrl(Uri.parse(downloadUrl))) {
        await launchUrl(
          Uri.parse(downloadUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $downloadUrl';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open URL: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isDownloading = false; // hiding progress indicator
      });
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
      body: Stack(
        children: [
          BlocProvider(
            create: (context) {
              final bloc = LibraryDownloadBloc();
              bloc.add(LoadLibraryFiles(getUserId()));
              return bloc;
            },
            child: BlocBuilder<LibraryDownloadBloc, LibraryDownloadState>(
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
                                onPressed: () => _downloadFile(file.filePath),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if (state is LibraryDownloadError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
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
          if (_isDownloading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}