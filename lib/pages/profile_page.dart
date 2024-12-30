import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/load_profile/load_profile_event.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
            context.read<LoadProfileBloc>().add(LoadUserProfile(email: authState.email));

            return Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
                centerTitle: true,
                toolbarHeight: 60,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                  ),
                ],
              ),
              body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
                builder: (context, state) {
                  if (state is LoadProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadProfileLoaded) {
                    return _buildProfileContent(context, state.profileData, screenWidth);
                  } else if (state is LoadProfileError) {
                    return Center(child: Text("Error: ${state.errorMessage}"));
                  }
                  return const Center(child: Text('No profile data found.'));
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
          CircleAvatar(
            radius: screenWidth * 0.15,
            backgroundImage: profileData['profilePicture'] != null
                ? NetworkImage(profileData['profilePicture'])
                : const AssetImage('assets/profile_picture.png') as ImageProvider,
          ),
          const SizedBox(height: 8),
          Text(
            profileData['fullName'] ?? "Name not found",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoSection(profileData, screenWidth),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> profileData, double screenWidth) {
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
            "User Information",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const Divider(),
          _buildListTile(Icons.person, "Full Name", profileData['fullName'] ?? "Unknown"),
          _buildListTile(Icons.email, "Email", profileData['email'] ?? "Unknown"),
          _buildListTile(Icons.phone, "Contact", profileData['contactNumber'] ?? "Unknown"),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}