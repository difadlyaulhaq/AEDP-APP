import 'package:flutter/material.dart';

class Detail_material extends StatelessWidget {
  const Detail_material({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15), // Adjust height dynamically
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
              onPressed: () => Navigator.pushNamed(context, '/student_home'),
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
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: ListView(
          children: [
            _buildMaterialCard(context, 'New Material', 'Integers and Their Operations'),
            _buildAssignmentCard(context, 'New Assignment', 'Exercise 2: Linear Equations in One Variable'),
            _buildMaterialCard(context, 'New Material', 'The Pythagorean Theorem'),
            _buildAssignmentCard(context, 'New Assignment', 'Exercise 1: Polygons: Triangles and Quadrilaterals'),
            _buildMaterialCard(context, 'New Material', 'Elementary Geometry'),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialCard(BuildContext context, String title, String subtitle) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.04,
          horizontal: screenWidth * 0.05,
        ), // Dynamic padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, // Dynamic font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02), // Dynamic spacing
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Icon(Icons.file_download, color: Colors.black54, size: screenWidth * 0.06), // Dynamic icon size
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, String title, String subtitle) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.04,
          horizontal: screenWidth * 0.05,
        ), // Dynamic padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, // Dynamic font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02), // Dynamic spacing
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Icon(Icons.file_download, color: Colors.black54, size: screenWidth * 0.06), // Dynamic icon size
          ],
        ),
      ),
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
