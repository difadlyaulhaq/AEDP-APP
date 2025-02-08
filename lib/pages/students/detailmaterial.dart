import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/material_and_subject/material_event.dart';
import 'package:project_aedp/bloc/material_and_subject/material_state.dart' as custom;
import 'package:project_aedp/bloc/material_and_subject/teacher_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMaterial extends StatefulWidget {
  final String subject;
  final String subjectId;

  const DetailMaterial({
    super.key,
    required this.subject,
    required this.subjectId,
  });

  @override
  State<DetailMaterial> createState() => _DetailMaterialState();
}

class _DetailMaterialState extends State<DetailMaterial> {
  late MaterialBloc _materialBloc;

  @override
  void initState() {
    super.initState();
    _materialBloc = MaterialBloc();
    _materialBloc.add(FetchMaterials(subjectId: widget.subjectId));
  }

  @override
  void dispose() {
    _materialBloc.close();
    super.dispose();
  }

  Future<void> _openFile(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open URL: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider.value(
      value: _materialBloc,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.15),
          child: ClipPath(
            clipper: CustomAppBarClipper(),
            child: AppBar(
              title: Text(
                '${widget.subject} Materials',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
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
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<MaterialBloc, custom.MaterialState>(
            builder: (context, state) {
              if (state is custom.MaterialLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is custom.MaterialLoaded) {
                if (state.materials.isEmpty) {
                  return const Center(child: Text('No materials available.'));
                }
                return ListView.builder(
                  itemCount: state.materials.length,
                  itemBuilder: (context, index) {
                    final material = state.materials[index];
                    return _buildMaterialCard(material.title, material.description, material.fileLink);
                  },
                );
              } else if (state is custom.MaterialError) {
                return Center(child: Text('Error: ${state.errorMessage}'));
              }
              return const Center(child: Text('No materials available.'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialCard(String title, String description, String fileLink) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _openFile(fileLink),
              child: Text(
                'Open Material',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
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
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomAppBarClipper oldClipper) => false;
}
