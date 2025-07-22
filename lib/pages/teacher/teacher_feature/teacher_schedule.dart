import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:project_aedp/bloc/schedule/schedule_event.dart';
import 'package:project_aedp/bloc/schedule/schedule_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherSchedule extends StatefulWidget {
  const TeacherSchedule({super.key});

  @override
  State<TeacherSchedule> createState() => _TeacherScheduleState();
}

class _TeacherScheduleState extends State<TeacherSchedule> {
  // Set untuk melacak item mana yang sedang diunduh
  final Set<String> _downloadingItemIds = {};

  // Fungsi untuk mengunduh dan membuka jadwal dari URL
  Future<void> _downloadAndOpenSchedule(String pdfPath, String itemId) async {
    if (_downloadingItemIds.contains(itemId)) return;

    try {
      setState(() {
        _downloadingItemIds.add(itemId);
      });

      // URL dasar tempat file PDF disimpan
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();

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
        _downloadingItemIds.remove(itemId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).teacherSchedule),
        backgroundColor: const Color(0xFF1E71A2),
        centerTitle: true,
      ),
      // Langkah 1: Membangun UI berdasarkan status profil
      body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
        builder: (context, profileState) {
          // Tampilkan indikator loading saat profil sedang dimuat
          if (profileState is LoadProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tampilkan pesan error jika gagal memuat profil
          if (profileState is LoadProfileError) {
            return Center(child: Text(profileState.message));
          }

          // Jika profil berhasil dimuat, lanjutkan untuk memuat jadwal
          if (profileState is LoadProfileLoaded) {
            final teacherId = profileState.profileData['id']?.toString();

            if (teacherId == null) {
              return const Center(child: Text('Teacher ID not found.'));
            }

            // Langkah 2: Sediakan ScheduleBloc dan langsung trigger event FetchSchedule
            return BlocProvider(
              create: (context) => ScheduleBloc(firestore: context.read())
                ..add(FetchSchedule(userId: teacherId)),
              // Langkah 3: Gunakan BlocConsumer untuk membangun UI jadwal dan menangani error
              child: BlocConsumer<ScheduleBloc, ScheduleState>(
                listener: (context, scheduleState) {
                  if (scheduleState is ScheduleError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(scheduleState.error)),
                    );
                  }
                },
                builder: (context, scheduleState) {
                  // Tampilkan indikator loading saat jadwal sedang dimuat
                  if (scheduleState is ScheduleLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Jika jadwal berhasil dimuat, tampilkan dalam daftar
                  if (scheduleState is ScheduleLoaded) {
                    if (scheduleState.scheduleData.isEmpty) {
                      return Center(
                          child: Text(S.of(context).noScheduleAvailable));
                    }
                    // Gunakan ListView.builder untuk menampilkan daftar jadwal
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: scheduleState.scheduleData.length,
                      itemBuilder: (context, index) {
                        final classInfo = scheduleState.scheduleData[index];
                        return _buildClassCard(classInfo);
                      },
                    );
                  }

                  // Tampilan default atau jika terjadi error
                  return Center(child: Text(S.of(context).loadingLabel));
                },
              ),
            );
          }

          // Tampilan fallback jika status profil tidak terdefinisi
          return Center(child: Text(S.of(context).noProfileData));
        },
      ),
    );
  }

  // Widget untuk membangun setiap kartu jadwal
  Widget _buildClassCard(Map<String, dynamic> classInfo) {
    final itemId = classInfo['id']?.toString() ?? UniqueKey().toString();
    final pdfPath = classInfo['pdf_path'] as String?;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classInfo['subject'] ?? 'No Subject',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.school, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${S.of(context).grade} ${classInfo['class']}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            if (pdfPath != null && pdfPath.isNotEmpty) ...[
              const SizedBox(height: 12),
              Center(
                child: _downloadingItemIds.contains(itemId)
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () => _downloadAndOpenSchedule(pdfPath, itemId),
                        icon: const Icon(Icons.download),
                        label: Text(S.of(context).download),
                      ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}