import 'package:flutter/material.dart';
import 'package:project_aedp/pages/teacher/teacher_dashboard.dart';

class TeacherDetailmaterial extends StatelessWidget {
  const TeacherDetailmaterial({super.key});

  @override
  Widget build(BuildContext context) {
    // Getting the screen width and height for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15), // 15% of screen height
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
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherDashboard())),
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
            // Add Button with Dropdown Menu
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
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
            // Material and Assignment List
            Expanded(
              child: ListView(
                children: [
                  _buildMaterialCard('New Material', 'Integers and Their Operations', screenWidth),
                  _buildAssignmentCard('New Assignment', 'Exercise 2: Linear Equations in One Variable', screenWidth),
                  _buildMaterialCard('New Material', 'The Pythagorean Theorem', screenWidth),
                  _buildAssignmentCard('New Assignment', 'Exercise 1: Polygons: Triangles and Quadrilaterals', screenWidth),
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
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: screenWidth * 0.05), // Adjusted padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Font size adjusted based on screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, // Font size adjusted based on screen width
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

  Widget _buildAssignmentCard(String title, String subtitle, double screenWidth) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: screenWidth * 0.05), // Adjusted padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Font size adjusted based on screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, // Font size adjusted based on screen width
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

  void _showUploadDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                // Handle upload logic here
                Navigator.pop(context);
              },
              child: const Text('Upload'),
            ),
          ],
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
