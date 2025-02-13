import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/certificates_download/certificates_download_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _downloadCertificate(BuildContext context, CertificateItem item) async {
    try {
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(item.pdfPath).toString();

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
          if (state is CertificatesLoading) {
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