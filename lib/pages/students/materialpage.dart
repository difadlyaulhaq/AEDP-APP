import 'package:flutter/material.dart';
import 'package:project_aedp/pages/students/detailmaterial.dart';

class Student_MaterialPage extends StatelessWidget {
  const Student_MaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15), // Responsif tinggi AppBar
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
                    Color.fromRGBO(30, 113, 162, 1), // Warna biru terang
                    Color.fromRGBO(11, 42, 60, 1), // Warna biru gelap
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: screenWidth * 0.07, // Responsif ukuran icon
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Material',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.06, // Responsif ukuran teks
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03), // Responsif padding
        child: GridView.count(
          crossAxisCount: screenWidth > 600 ? 3 : 2, // Sesuaikan jumlah kolom berdasarkan lebar layar
          crossAxisSpacing: screenWidth * 0.02, // Responsif jarak antar kolom
          mainAxisSpacing: screenHeight * 0.02, // Responsif jarak antar baris
          children: [
            _buildTextItem(context, 'History'),
            _buildTextItem(context, 'Math'),
            _buildTextItem(context, 'Science'),
            _buildTextItem(context, 'Art'),
            _buildTextItem(context, "Arabic"),
            _buildTextItem(context, "Music"),
            _buildTextItem(context, 'Geography'),
            _buildTextItem(context, 'English'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextItem(BuildContext context, String subject) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Detail_material()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E70A0), // Warna latar
          borderRadius: BorderRadius.circular(screenWidth * 0.03), // Responsif radius
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(screenWidth * 0.03), // Responsif padding
        child: Text(
          subject,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.04, // Responsif ukuran teks
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // Mulai dari kiri bawah
    path.quadraticBezierTo(
        0, size.height, 40, size.height); // Lengkungan di pojok kiri
    path.lineTo(
        size.width - 40, size.height); // Garis lurus di bawah tengah
    path.quadraticBezierTo(size.width, size.height, size.width,
        size.height - 40); // Lengkungan di pojok kanan
    path.lineTo(size.width, 0); // Menuju ke kanan atas
    path.close(); // Menutup jalur
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // Tidak perlu reclip
  }
}
