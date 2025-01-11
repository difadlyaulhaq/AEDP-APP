import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/teacher_materi/material_event.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/pages/teacher/teacher_detailmaterial.dart';
import '../../bloc/teacher_materi/teacher_bloc.dart';

class TeacherMaterialPage extends StatefulWidget {
  const TeacherMaterialPage({super.key});

  @override
  TeacherMaterialPageState createState() => TeacherMaterialPageState();
}

class TeacherMaterialPageState extends State<TeacherMaterialPage> {
  List<Map<String, dynamic>> filteredSubjects = List.from(subjects);
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.2),
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
                    Color(0xFF1E70A0),
                    Color(0xFF0B2A3C),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              S.of(context).subjectsTitle,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.065,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
                onPressed: _showFilterDialog,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 600 ? 3 : 2,
            crossAxisSpacing: screenWidth * 0.04,
            mainAxisSpacing: screenHeight * 0.02,
          ),
          itemCount: filteredSubjects.length,
          itemBuilder: (context, index) {
            final subject = filteredSubjects[index];
            return _buildCardItem(context, subject['name'], subject['icon']);
          },
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).filterSubjects),
          content: DropdownButton<String>(
            value: selectedFilter,
            items: <String>[
              S.of(context).all,
              S.of(context).math,
              S.of(context).science,
              S.of(context).history,
              S.of(context).geography,
              S.of(context).art,
              S.of(context).music,
              S.of(context).arabic,
              S.of(context).english
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedFilter = value!;
                _applyFilter(selectedFilter);
              });
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
          ],
        );
      },
    );
  }

  void _applyFilter(String filter) {
    if (filter == S.of(context).all) {
      setState(() {
        filteredSubjects = List.from(subjects);
      });
    } else {
      setState(() {
        filteredSubjects = subjects
            .where((subject) =>
                subject['name'].toLowerCase().contains(filter.toLowerCase()))
            .toList();
      });
    }
  }

  Widget _buildCardItem(BuildContext context, String subject, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  MaterialBloc()..add(FetchMaterials(subjectId: subject)),
              child: TeacherDetailMaterial(subject: subject),
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E88E5), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: screenWidth * 0.1,
              ),
              SizedBox(height: screenWidth * 0.02),
              Text(
                subject,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.045,
                ),
                textAlign: TextAlign.center,
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
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

final List<Map<String, dynamic>> subjects = [
  {'name': S.current.history, 'icon': Icons.history_edu},
  {'name': S.current.math, 'icon': Icons.calculate},
  {'name': S.current.science, 'icon': Icons.science},
  {'name': S.current.art, 'icon': Icons.brush},
  {'name': S.current.arabic, 'icon': Icons.language},
  {'name': S.current.music, 'icon': Icons.music_note},
  {'name': S.current.geography, 'icon': Icons.public},
  {'name': S.current.english, 'icon': Icons.book},
];
