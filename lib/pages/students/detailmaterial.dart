import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/teacher_materi/material_event.dart';
import 'package:project_aedp/bloc/teacher_materi/material_state.dart' as custom;
import 'package:project_aedp/bloc/teacher_materi/teacher_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMaterial extends StatelessWidget {
  final String subjectId;
  final String subjectName;
  final String subject;
  
  const DetailMaterial({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Remove the BlocProvider here since we're providing it from the navigation
    return BlocProvider(
      create: (context) => MaterialBloc()..add(FetchMaterials(subjectId: subject)),
      child: Scaffold(
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
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                '$subjectName Materials',
                style: const TextStyle(
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
              const SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<MaterialBloc, custom.MaterialState>(
                  builder: (context, state) {
                    if (state is custom.MaterialLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is custom.MaterialLoaded) {
                      if (state.materials.isEmpty) {
                        return const Center(
                            child: Text('No materials available.'));
                      }
                      return ListView.builder(
                        itemCount: state.materials.length,
                        itemBuilder: (context, index) {
                          final material = state.materials[index];
                          return buildMaterialCard(
                            material.title,
                            material.description,
                            material.fileLink,
                            screenWidth,
                          );
                        },
                      );
                    } else if (state is custom.MaterialError) {
                      return Center(
                          child: Text('Error: ${state.errorMessage}'));
                    }
                    return const Center(child: Text('No materials available.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMaterialCard(
      String title, String subtitle, String fileLink, double screenWidth) {
    Future<void> openFile(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) {
        throw 'Could not launch $url';
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: screenWidth * 0.05,
        ),
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
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => openFile(fileLink),
                  child: Text(
                    fileLink,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
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
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(0, size.height, 40, size.height);
    path.lineTo(size.width - 40, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomAppBarClipper oldClipper) {
    return false;
  }
}
