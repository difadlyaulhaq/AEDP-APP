import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_event.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/load_profile/load_profile_event.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/bloc/language/language_cubit.dart';
import 'package:project_aedp/generated/l10n.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          context.go('/select-role');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoginSuccess) {
            context.read<LoadProfileBloc>().add(LoadUserProfile(id: authState.userId.toString()));
  
            return Scaffold(
              appBar: AppBar(
                actions: [
                  _buildLanguageDropdown(context),
                ],
              ),
              body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
                builder: (context, state) {
                  if (state is LoadProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadProfileLoaded) {
                    return _buildProfileContent(context, state.profileData, screenWidth);
                  } else if (state is LoadProfileError) {
                    return Center(child: Text(S.of(context).errorLabel(state.message)));
                  }
                  return Center(child: Text(S.of(context).noProfileData));
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, Map<String, dynamic> profileData, double screenWidth) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CircleAvatar(
          //   radius: screenWidth * 0.15,
          //   backgroundImage: profileData['profilePicture'] != null
          //       ? NetworkImage(profileData['profilePicture'])
          //       : const AssetImage('assets/profile_picture.png') as ImageProvider,
          // ),
          const SizedBox(height: 8),
          Text(
            profileData['fullName'] ?? S.of(context).nameNotFound,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoSectionByRole(context, profileData, screenWidth),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              S.of(context).logout,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSectionByRole(BuildContext context, Map<String, dynamic> profileData, double screenWidth) {
    final role = profileData['role']?.toLowerCase();

    switch (role) {
      case 'teacher':
        return _buildTeacherSection(context, profileData, screenWidth);
      case 'student':
        return _buildStudentSection(context, profileData, screenWidth);
      case 'parent':
        return _buildParentSection(context, profileData, screenWidth);
      default:
        return Center(child: Text(S.of(context).unknownRole));
    }
  }

  Widget _buildTeacherSection(BuildContext context, Map<String, dynamic> profileData, double screenWidth) {
    return _buildInfoContainer(
      context,
      screenWidth,
      S.of(context).teacherInfo,
      [
        _buildListTile(context, Icons.location_on, S.of(context).address, profileData['address'] ?? S.of(context).unknown),
        _buildListTile(context, Icons.phone, S.of(context).contact, profileData['contact']?.toString() ?? S.of(context).unknown),
        _buildListTile(context, Icons.call, S.of(context).whatsapp, profileData['whatsapp'] ?? S.of(context).unknown),
        _buildListTile(context, Icons.class_, S.of(context).classes, (profileData['classes'] as List<String>).join(', ')),
      ],
    );
  }

  Widget _buildStudentSection(BuildContext context, Map<String, dynamic> profileData, double screenWidth) {
    return _buildInfoContainer(
      context,
      screenWidth,
      S.of(context).studentInfo,
      [
        _buildListTile(context, Icons.cake, S.of(context).dateOfBirth, profileData['date_of_birth'] ?? S.of(context).unknown),
        _buildListTile(context, Icons.place, S.of(context).placeOfBirth, profileData['place_of_birth'] ?? S.of(context).unknown),
        _buildListTile(context, Icons.school, S.of(context).gradeClass, profileData['grade_class'] ?? S.of(context).unknown),
        _buildListTile(context, Icons.badge, S.of(context).schoolId(''), profileData['school_id'] ?? S.of(context).unknown),
      ],
    );
  }

Widget _buildParentSection(BuildContext context, Map<String, dynamic> profileData, double screenWidth) {
  return _buildInfoContainer(
    context,
    screenWidth,
    S.of(context).parentInfo,
    [
      _buildListTile(context, Icons.location_on, S.of(context).address, profileData['address'] ?? S.of(context).unknown),
      _buildListTile(context, Icons.person, S.of(context).fatherName, profileData['father_name'] ?? S.of(context).unknown),
      _buildListTile(context, Icons.person, S.of(context).mother_name, profileData['mother_name'] ?? S.of(context).unknown), // Pastikan ini ada
      _buildListTile(context, Icons.person, S.of(context).studentName, profileData['student_name'] ?? S.of(context).unknown),
      _buildListTile(context, Icons.phone, S.of(context).contact, profileData['contact'] ?? S.of(context).unknown),
      _buildListTile(context, Icons.call, S.of(context).whatsapp, profileData['whatsapp'] ?? S.of(context).unknown),
    ],
  );
}


  Widget _buildInfoContainer(BuildContext context, double screenWidth, String title, List<Widget> content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const Divider(),
          ...content,
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    final cubit = context.read<LanguageCubit>();
    return DropdownButton<String>(
      value: Localizations.localeOf(context).languageCode,
      icon: const Icon(Icons.language, color: Colors.black),
      underline: const SizedBox(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          cubit.changeLanguage(Locale(newValue));
        }
      },
      items: [
        DropdownMenuItem(
          value: 'en',
          child: Text(S.of(context).language_english),
        ),
        DropdownMenuItem(
          value: 'pt',
          child: Text(S.of(context).language_portuguese),
        ),
        DropdownMenuItem(
          value: 'ar',
          child: Text(S.of(context).language_arabic),
        ),
      ],
    );
  }
}