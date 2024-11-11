import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView( // Enables scrolling
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Profile Picture and Name
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_picture.png'), // Update with your image asset
              ),
              const SizedBox(height: 8),
              const Text(
                "Difa Dlyaul Haq",
                style: TextStyle(
                  fontSize: 22,
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
                    const Text(
                      "Data",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Divider(),

                    // User Information
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Name:"),
                      subtitle: Text("Difa Dlyaul Haq"),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text("Email:"),
                      subtitle: Text("difadlyaulhaq@students.ac.ae"),
                    ),
                    ListTile(
                      leading: Icon(Icons.badge),
                      title: Text("Student ID:"),
                      subtitle: Text("24.1234.07"),
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text("Parents Name:"),
                      subtitle: Text("Difa Dlyaul Haq Father"),
                    ),
                    ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text("Parent Email:"),
                      subtitle: Text("difasfather@gmail.com"),
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
