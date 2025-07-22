import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:project_aedp/bloc/schedule/schedule_event.dart';
import 'package:project_aedp/bloc/schedule/schedule_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/widget/Teacher_schedule_widgets/class_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final Set<String> _downloadingItemIds = {};

  Future<void> _downloadAndOpenSchedule(String pdfPath, String itemId) async {
    try {
      setState(() {
        _downloadingItemIds.add(itemId);
      });

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
        title: Text(S.of(context).scheduleTitle),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E71A2),
      ),
      body: BlocProvider(
        create: (context) {
          final scheduleBloc = ScheduleBloc(firestore: context.read());
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthLoginSuccess) {
            final userId = authState.userId.toString();
            scheduleBloc.add(FetchSchedule(userId: userId));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).errorLabel('User not logged in')),
              ),
            );
          }
          return scheduleBloc;
        },
        child: BlocConsumer<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ScheduleLoaded) {
              final scheduleData = state.scheduleData;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: scheduleData.length,
                itemBuilder: (context, index) {
                  final classInfo = scheduleData[index];
                  return ClassCard(classInfo: classInfo);
                },
              );
            }

            return Center(child: Text(S.of(context).loadingLabel));
          },
        ),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classInfo) {
    final itemId = classInfo['id'] ?? '';

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
            Row(
              children: [
                const Icon(Icons.school, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Grade ${classInfo['class']}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (classInfo['pdf_path'] != null)
              _downloadingItemIds.contains(itemId)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => _downloadAndOpenSchedule(
                        classInfo['pdf_path'],
                        itemId,
                      ),
                      icon: const Icon(Icons.download),
                      label: const Text('Download Schedule'),
                    ),
          ],
        ),
      ),
    );
  }
}