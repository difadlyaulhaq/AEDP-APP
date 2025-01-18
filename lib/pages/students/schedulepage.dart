import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:project_aedp/bloc/schedule/schedule_event.dart';
import 'package:project_aedp/bloc/schedule/schedule_state.dart';
import 'package:project_aedp/generated/l10n.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with TickerProviderStateMixin {
  late TabController _tabController;

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
                  'This permission is required to download and save schedules. Please enable it in settings.',
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

  Future<void> _downloadAndOpenSchedule(BuildContext context, String pdfPath) async {
    try {
      final downloadPath = await _getDownloadPath(context);
      if (downloadPath == null) {
        throw Exception('Storage permission not granted');
      }

      context.read<ScheduleBloc>().add(DownloadSchedule(filePath: pdfPath));

      await for (final state in context.read<ScheduleBloc>().stream) {
        if (state is ScheduleDownloaded) {
          await OpenFile.open(state.filePath);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded to ${state.filePath}')),
          );
          break;
        } else if (state is ScheduleError) {
          throw Exception(state.error);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
              _tabController = TabController(
                length: scheduleData.keys.length, 
                vsync: this
              );

              return Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: scheduleData.keys.map((day) => Tab(text: day)).toList(),
                    indicatorColor: Colors.blue,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: scheduleData.keys.map((day) {
                        final daySchedule = scheduleData[day] ?? [];
                        return daySchedule.isNotEmpty
                            ? ListView(
                                padding: const EdgeInsets.all(16),
                                children: daySchedule.map((classInfo) {
                                  return _buildClassCard(classInfo);
                                }).toList(),
                              )
                            : Center(
                                child: Text(S.of(context).noScheduleAvailable),
                              );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }

            return Center(child: Text(S.of(context).loadingLabel));
          },
        ),
      ),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classInfo) {
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
              ElevatedButton.icon(
                onPressed: () => _downloadAndOpenSchedule(
                  context,
                  classInfo['pdf_path'],
                ),
                icon: const Icon(Icons.download),
                label: const Text('Download Schedule'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}