import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/teacher_materi/material_model.dart';
import '../../bloc/teacher_materi/teacher_bloc.dart';
import '../../bloc/teacher_materi/material_event.dart';
import '../../bloc/teacher_materi/material_state.dart'
    as teacher_material_state;
// import '../../bloc/teacher_materi/material_model.dart'; // Remove unused import
import 'package:url_launcher/url_launcher.dart';

class TeacherDetailMaterial extends StatelessWidget {
  final String subject;

  const TeacherDetailMaterial({super.key, required this.subject});

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
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '$subject Materials',
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
      body: BlocProvider(
        create: (context) =>
            MaterialBloc()..add(FetchMaterials(subjectId: subject)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'upload_material') {
                      showUploadDialog(context, 'Upload Material', subject);
                    } else if (value == 'upload_assignment') {
                      showUploadDialog(context, 'Upload Assignment', subject);
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
                      child: Text('Upload Assignment '),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<MaterialBloc,
                    teacher_material_state.MaterialState>(
                  builder: (context, state) {
                    if (state is teacher_material_state.MaterialLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is teacher_material_state.MaterialLoaded) {
                      return ListView.builder(
                        itemCount: state.materials.length,
                        itemBuilder: (context, index) {
                          final material = state.materials[index];
                          return buildMaterialCard(
                            context,  
                            material.title,
                            material.description,
                            material.fileLink,
                            screenWidth,
                          );
                        },
                      );
                    } else if (state is teacher_material_state.MaterialError) {
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

  // Pass BuildContext to the method
Widget buildMaterialCard(BuildContext context, String title, String subtitle, String fileLink, double screenWidth) {
  Future<void> openFile(BuildContext context, String url) async {
  try {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      throw Exception('Invalid URL format');
    }

    // Add more specific URL handling
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      final bool canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(
          uri, 
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      } else {
        throw Exception('Could not launch URL');
      }
    } else if (uri.scheme == 'file') {
      // Handle file:// URLs if needed
      throw Exception('File URLs not supported');
    } else {
      throw Exception('Unsupported URL scheme');
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to open URL: ${e.toString()}'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
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
                onTap: () => openFile(context, fileLink), // Pass context here
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
        ],
      ),
    ),
  );
}


  void showUploadDialog(BuildContext context, String title, String subject) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final fileLinkController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                TextField(
                  controller: fileLinkController,
                  decoration: const InputDecoration(
                    labelText: 'File Link',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                final fileLink = fileLinkController.text.trim();

                final isValid = title.isNotEmpty &&
                    description.isNotEmpty &&
                    fileLink.isNotEmpty &&
                    Uri.tryParse(fileLink)?.hasAbsolutePath == true;

                if (isValid) {
                  final material = MaterialModel(
                    id: DateTime.now().toIso8601String(),
                    title: title,
                    description: description,
                    fileLink: fileLink,
                    createdAt: DateTime.now(),
                    subjectId: subject,
                  );

                  BlocProvider.of<MaterialBloc>(context)
                      .add(AddMaterial(material));
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Material uploaded successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please fill all fields and provide a valid file link.'),
                    ),
                  );
                }
              },
              child: const Text('Upload'),
            ),
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
