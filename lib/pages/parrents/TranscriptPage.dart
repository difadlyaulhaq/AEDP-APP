import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/bloc/transcript_downloads/transcript_downloads_bloc.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _downloadTranscript(BuildContext context, TranscriptItem item) async {
    try {
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(item.filePath).toString();

      if (await canLaunchUrl(Uri.parse(downloadUrl))) {
        await launchUrl(
          Uri.parse(downloadUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $downloadUrl';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open URL: ${e.toString()}')),
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
          if (state is TranscriptsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TranscriptsLoaded) {
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