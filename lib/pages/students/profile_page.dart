import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size using MediaQuery
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView( // Enables scrolling
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Profile Picture and Name
              CircleAvatar(
                radius: screenWidth * 0.15, // Adjust size based on screen width
                backgroundImage: const AssetImage('assets/profile_picture.png'), // Update with your image asset
              ),
              const SizedBox(height: 8),
              Text(
                "Difa Dlyaul Haq",
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Adjust font size based on screen width
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
                      "Data",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, // Adjust font size based on screen width
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Divider(),

                    // User Information
                    const ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Name:"),
                      subtitle: Text("Difa Dlyaul Haq"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.email),
                      title: Text("Email:"),
                      subtitle: Text("difadlyaulhaq@students.ac.ae"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.badge),
                      title: Text("Student ID:"),
                      subtitle: Text("24.1234.07"),
                    ),
                    const ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text("Parents Name:"),
                      subtitle: Text("Difa Dlyaul Haq Father"),
                    ),
                    const ListTile(
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
