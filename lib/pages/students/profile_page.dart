import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart' as auth_bloc;
import 'package:project_aedp/bloc/auth/auth_event.dart' as auth_event;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size using MediaQuery
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Trigger logout event
              context.read<auth_bloc.AuthBloc>().add(auth_event.AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Profile Picture and Name
              CircleAvatar(
                radius: screenWidth * 0.15,
                backgroundImage: const AssetImage('assets/profile_picture.png'),
              ),
              const SizedBox(height: 8),
              Text(
                "Difa Dlyaul Haq",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Data Section
              Container(
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

                    // User Information List
                    _buildListTile(Icons.person, "Name", "Difa Dlyaul Haq"),
                    _buildListTile(Icons.email, "Email", "difadlyaulhaq@students.ac.ae"),
                    _buildListTile(Icons.badge, "Student ID", "24.1234.07"),
                    _buildListTile(Icons.person_outline, "Parents Name", "Difa Dlyaul Haq Father"),
                    _buildListTile(Icons.email_outlined, "Parent Email", "difasfather@gmail.com"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build ListTile
  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
