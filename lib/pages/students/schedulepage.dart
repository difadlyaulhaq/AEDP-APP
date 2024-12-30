import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/theme/theme.dart';
import 'package:project_aedp/bloc/schedule/schedule_bloc.dart';
import 'package:project_aedp/bloc/schedule/schedule_event.dart';
import 'package:project_aedp/bloc/schedule/schedule_state.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ScheduleBloc>(context).add(FetchSchedule());
  }

  // Widget for each class card
  Widget _buildClassCard(Map<String, dynamic> classInfo) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classInfo['subject'] ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              classInfo['time'] ?? '',
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.black54, size: 16),
                const SizedBox(width: 4),
                Text(
                  classInfo['class'] ?? '',
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ScheduleLoaded) {
          final scheduleData = state.scheduleData;
          _tabController = TabController(length: scheduleData.keys.length, vsync: this);

          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).scheduleTitle, style: whiteColorTextStyle),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E71A2), Color(0xFF0B2A3C)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: scheduleData.keys.map((day) => Tab(text: day)).toList(),
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[400],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: scheduleData.keys.map((day) {
                final daySchedule = scheduleData[day]!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: daySchedule.isNotEmpty
                      ? ListView(
                          children: daySchedule.map((classInfo) => _buildClassCard(classInfo)).toList(),
                        )
                      : Center(
                          child: Text(
                            S.of(context).noScheduleAvailable,
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                );
              }).toList(),
            ),
          );
        } else if (state is ScheduleError) {
          return Center(child: Text(state.error));
        } else {
          return const Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}
