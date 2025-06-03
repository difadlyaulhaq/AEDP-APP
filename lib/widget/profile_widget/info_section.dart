import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';

class InfoSection extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final double screenWidth;

  const InfoSection({
    super.key,
    required this.profileData,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final role = profileData['role']?.toLowerCase();

    switch (role) {
      case 'teacher':
        return _buildTeacher(context);
      case 'student':
        return _buildStudent(context);
      case 'parent':
        return _buildParent(context);
      default:
        return Center(child: Text(S.of(context).unknownRole));
    }
  }

  Widget _buildTeacher(BuildContext context) {
    return _buildInfoContainer(
      context,
      S.of(context).teacherInfo,
      [
        _infoTile(context, Icons.location_on, S.of(context).address, profileData['address']),
        _infoTile(context, Icons.phone, S.of(context).id_number, profileData['contact']),
        _infoTile(context, Icons.call, S.of(context).whatsapp, profileData['whatsapp']),
        _infoTile(context, Icons.class_, S.of(context).classes,
            (profileData['classes'] as List<dynamic>?)?.join(', ')),
      ],
    );
  }

  Widget _buildStudent(BuildContext context) {
    return _buildInfoContainer(
      context,
      S.of(context).studentInfo,
      [
        _infoTile(context, Icons.cake, S.of(context).dateOfBirth, profileData['date_of_birth']),
        _infoTile(context, Icons.place, S.of(context).placeOfBirth, profileData['place_of_birth']),
        _infoTile(context, Icons.school, S.of(context).gradeClass, profileData['grade_class']),
        _infoTile(context, Icons.badge, S.of(context).schoolId(''), profileData['school_id']),
      ],
    );
  }

  Widget _buildParent(BuildContext context) {
    return _buildInfoContainer(
      context,
      S.of(context).parentInfo,
      [
        _infoTile(context, Icons.location_on, S.of(context).address, profileData['address']),
        _infoTile(context, Icons.person, S.of(context).fatherName, profileData['father_name']),
        _infoTile(context, Icons.person, S.of(context).mother_name, profileData['mother_name']),
        _infoTile(context, Icons.person, S.of(context).studentName, profileData['student_name']),
        _infoTile(context, Icons.phone, S.of(context).id_number, profileData['contact']),
        _infoTile(context, Icons.call, S.of(context).whatsapp, profileData['whatsapp']),
      ],
    );
  }

  Widget _buildInfoContainer(BuildContext context, String title, List<Widget> content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              )),
          const Divider(),
          ...content,
        ],
      ),
    );
  }

  Widget _infoTile(BuildContext context, IconData icon, String title, dynamic subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle?.toString() ?? S.of(context).unknown),
    );
  }
}
