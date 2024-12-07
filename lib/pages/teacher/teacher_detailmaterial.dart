import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_aedp/pages/teacher/inputgrade.dart';
import 'package:project_aedp/pages/teacher/teacher_dashboard.dart';

class TeacherDetailMaterial extends StatelessWidget {
  const TeacherDetailMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15),
        child: ClipPath(
          clipper: CustomAppBarClipper(),
          child: AppBar(
            automaticallyImplyLeading: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(30, 113, 162, 1),
                    Color.fromRGBO(11, 42, 60, 1),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherDashboard(),
                ),
              ),
            ),
            title: const Text(
              'Math',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'upload_material') {
                    _showUploadDialog(context, 'Upload Material');
                  } else if (value == 'upload_assignment') {
                    _showUploadDialog(context, 'Upload Assignment');
                  }
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: Color.fromRGBO(30, 113, 162, 1),
                  size: 32,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'upload_material',
                    child: Text('Upload Material'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'upload_assignment',
                    child: Text('Upload Assignment'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  _buildMaterialCard('New Material', 'Integers and Their Operations', screenWidth),
                  _buildAssignmentCard(context, 'New Assignment', 'Exercise 2: Linear Equations in One Variable', screenWidth),
                  _buildMaterialCard('New Material', 'The Pythagorean Theorem', screenWidth),
                  _buildMaterialCard('New Material', 'Elementary Geometry', screenWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialCard(String title, String subtitle, double screenWidth) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: screenWidth * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const Icon(Icons.file_download, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, String title, String subtitle, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InputGradePage(
              assignmentTitle: title,
              assignmentSubtitle: subtitle,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: screenWidth * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.file_download, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadDialog(BuildContext context, String title) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String? filePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles();
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            filePath = result.files.single.path;
                          });
                        }
                      },
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Document'),
                    ),
                    if (filePath != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'File Selected: ${filePath!.split('/').last}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        filePath != null) {
                      print('Title: ${titleController.text}');
                      print('Description: ${descriptionController.text}');
                      print('File Path: $filePath');
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields and upload a file.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Upload'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(0, size.height, 40, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
