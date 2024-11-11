import 'package:flutter/material.dart';
import 'package:project_aedp/pages/students/detailmaterial.dart';

class Material_page extends StatelessWidget {
  const Material_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(120.0), // Adjust the height as needed
        child: ClipPath(
          clipper: CustomAppBarClipper(), // Custom clipper for rounded corners
          child: AppBar(
            automaticallyImplyLeading: true, // Removes the back button if any
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(30, 113, 162, 1), // Light blue color
                    Color.fromRGBO(11, 42, 60, 1), // Darker blue color
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context), // Use pop to go back
            ),
            title: const Text(
              'Material', // Title can be dynamic based on _selectedIndex if needed
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
        padding: const EdgeInsets.all(8.0), // Reduced padding for compactness
        child: GridView.count(
          crossAxisCount: 2, // 2 items in each row
          crossAxisSpacing: 8.0, // Reduced space between columns
          mainAxisSpacing: 8.0, // Reduced space between rows
          children: [
            _buildTextItem(context, 'History'),
            _buildTextItem(context, 'Math'),
            _buildTextItem(context, 'Science'),
            _buildTextItem(context, 'Art'),
            _buildTextItem(context, "Arabic"),
            _buildTextItem(context, "Music"),
            _buildTextItem(context, 'Geography'),
            _buildTextItem(context, 'English')
          ],
        ),
      ),
    );
  }

  Widget _buildTextItem(BuildContext context, String subject) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Detail_material()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E70A0), // Background color
          borderRadius: BorderRadius.circular(10), // Smaller corner radius
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0), // Reduced padding inside the box
        child: Text(
          subject,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16, // Smaller font size for compact display
            fontWeight: FontWeight.w500, // Lighter font weight for smaller text
          ),
          textAlign: TextAlign.center, // Center align the text
        ),
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // Start from the bottom-left corner
    path.quadraticBezierTo(
        0, size.height, 40, size.height); // Left corner curve
    path.lineTo(
        size.width - 40, size.height); // Straight line at the bottom middle
    path.quadraticBezierTo(size.width, size.height, size.width,
        size.height - 40); // Right corner curve
    path.lineTo(size.width, 0); // Go to the top-right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip as the shape doesn't change dynamically
  }
}
