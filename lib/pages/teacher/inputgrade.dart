import 'package:flutter/material.dart';

class InputGradePage extends StatefulWidget {
  final String assignmentTitle;
  final String assignmentSubtitle;

  const InputGradePage({
    super.key,
    required this.assignmentTitle,
    required this.assignmentSubtitle,
  });

  @override
  State<InputGradePage> createState() => _InputGradePageState();
}

class _InputGradePageState extends State<InputGradePage> {
  final List<Map<String, dynamic>> students = [
    {"name": "Arunika Santoso", "score": 90},
    {"name": "Damar Prasetya", "score": 85},
    {"name": "Naya Lestari", "score": 45},
    {"name": "Ardi Kusuma", "score": 0},
    {"name": "Keisha Putri", "score": 55},
    {"name": "Raka Wijaya", "score": null},
    {"name": "Zahra Mulyani", "score": null},
    {"name": "Rizky Mahendra", "score": null},
    {"name": "Farah Anggraini", "score": null},
    {"name": "Jovan Aditya", "score": null},
  ];

  void updateScore(int index, int? score) {
    setState(() {
      students[index]['score'] = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.assignmentTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(30, 113, 162, 1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Assignment Details
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Assignment Title",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.assignmentSubtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Marked",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(),
            // Student List
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey[200],
                      child: Text(
                        student['name'].substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(student['name']),
                    trailing: SizedBox(
                      width: screenWidth * 0.3,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: student['score']?.toString() ?? '__',
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                        ),
                        onChanged: (value) {
                          int? score = int.tryParse(value);
                          if (score != null && score >= 0 && score <= 100) {
                            updateScore(index, score);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
