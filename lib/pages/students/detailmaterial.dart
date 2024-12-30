import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/teacher_materi/material_event.dart';
import 'package:project_aedp/bloc/teacher_materi/material_state.dart' as material_state;
import 'package:project_aedp/bloc/teacher_materi/teacher_bloc.dart';

class DetailMaterial extends StatelessWidget {
  final String subject;
  
  const DetailMaterial({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => MaterialBloc()..add(FetchMaterials(subjects: [subject])),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.2),
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
                          Color(0xFF1E70A0),
                          Color(0xFF0B2A3C),
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
                      color: Colors.white.withAlpha(25),
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
                '$subject Materials',
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
        body: BlocBuilder<MaterialBloc, material_state.MaterialState>(
          builder: (context, state) {
            if (state is material_state.MaterialLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is material_state.MaterialError) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state is material_state.MaterialLoaded) {
              return Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: ListView.builder(
                  itemCount: state.materials.length,
                  itemBuilder: (context, index) {
                    final material = state.materials[index];
                    // Using a simple blue color for all cards until we determine the correct property
                    return _buildMaterialCard(
                      context,
                      title: material.title,
                      subtitle: material.description,
                      color: Colors.blue.shade100,
                      icon: Icons.book,
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('No materials available'));
          },
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
              Expanded(
                child: Column(
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
              ),
            ],
          ),
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
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}