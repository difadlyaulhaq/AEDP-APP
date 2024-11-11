import 'package:flutter/material.dart';
import 'package:project_aedp/theme/theme.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Schedule data for each day
  final Map<String, List<Map<String, String>>> scheduleData = {
    'Monday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Math', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '10:40 - 12:20', 'class': 'Class 6.2.1'},
    ],
    'Tuesday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Math', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '10:40 - 12:20', 'class': 'Class 6.2.1'},
    ],
    'Wednesday': [
      {'subject': 'Math', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
    ],
    'Thursday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
    ],
    'Friday': [
      {'subject': 'English', 'time': '07:00 - 08:40', 'class': 'Class 6.2.1'},
      {'subject': 'Science', 'time': '08:50 - 10:30', 'class': 'Class 6.2.1'},
    ],
    
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: scheduleData.keys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Widget for each class card
  Widget _buildClassCard(Map<String, String> classInfo) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classInfo['subject']!,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              classInfo['time']!,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.black54, size: 16),
                const SizedBox(width: 4),
                Text(
                  classInfo['class']!,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: whiteColorTextStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                : const Center(
                    child: Text(
                      'No schedule available',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Invoice'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: const Color(0xFF1E71A2),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}
