import 'package:flutter/material.dart';

class DetailMaterial extends StatelessWidget {
  const DetailMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.2), // Tinggi AppBar responsif
        child: ClipPath(
          clipper: CustomAppBarClipper(),
          child: AppBar(
            automaticallyImplyLeading: true,
            flexibleSpace: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1E70A0), // Biru terang
                        Color(0xFF0B2A3C), // Biru gelap
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.school,
                    size: screenWidth * 0.3,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: screenWidth * 0.07,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Math Materials',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ListView(
          children: [
            _buildMaterialCard(
              context,
              title: 'New Material',
              subtitle: 'Integers and Their Operations',
              color: Colors.blue.shade100,
              icon: Icons.book,
            ),
            _buildAssignmentCard(
              context,
              title: 'New Assignment',
              subtitle: 'Exercise 2: Linear Equations',
              color: Colors.orange.shade100,
              icon: Icons.assignment,
            ),
            _buildMaterialCard(
              context,
              title: 'New Material',
              subtitle: 'The Pythagorean Theorem',
              color: Colors.blue.shade100,
              icon: Icons.book,
            ),
            _buildAssignmentCard(
              context,
              title: 'New Assignment',
              subtitle: 'Exercise 1: Geometry Basics',
              color: Colors.orange.shade100,
              icon: Icons.assignment,
            ),
            _buildMaterialCard(
              context,
              title: 'New Material',
              subtitle: 'Elementary Geometry',
              color: Colors.blue.shade100,
              icon: Icons.book,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialCard(BuildContext context,
      {required String title,
      required String subtitle,
      required Color color,
      required IconData icon}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        // Implementasi saat kartu ditekan
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        color: color,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.04,
            horizontal: screenWidth * 0.05,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.blueAccent,
                size: screenWidth * 0.1,
              ),
              SizedBox(width: screenWidth * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context,
      {required String title,
      required String subtitle,
      required Color color,
      required IconData icon}) {
    return _buildMaterialCard(
      context,
      title: title,
      subtitle: subtitle,
      color: color,
      icon: icon,
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height, size.width,
        size.height - 40); // Desain lengkungan
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
