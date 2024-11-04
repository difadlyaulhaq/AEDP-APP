import 'package:flutter/material.dart';
import 'package:project_aedp/theme/theme.dart';

class Gradespage extends StatefulWidget {
  const Gradespage({super.key});

  @override
  State<Gradespage> createState() => _GradespageState();
}

class _GradespageState extends State<Gradespage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0), // Adjust the height as needed
        child: ClipPath(
          clipper: CustomAppBarClipper(), // Custom clipper for rounded corners
          child: AppBar(
            automaticallyImplyLeading: true, // Removes the back button if any
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(30, 113, 162, 1), // Light blue color
                    Color.fromRGBO(11, 42, 60, 1), // Darker blue color
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/student_home'),
            ),
            title: const Text(
              'Your Grades', // Title can be dynamic based on _selectedIndex if needed
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: const GradesWidget(),
    );
  }
}

class GradesWidget extends StatelessWidget {
  const GradesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define grades and calculate GPA
    List<int> grades = [82, 91, 100, 80, 19, 100, 100]; // Example grades
    double gpa = _calculateGPA(grades);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular GPA display
          Center(
            child: Container(
              height: 80.0, // Height of the circular container
              width: 80.0, // Width of the circular container
              
              decoration: BoxDecoration(
                color: const Color(0xFF1E70A0), // Background color of the circle
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                gpa.toStringAsFixed(2), // Display GPA rounded to 2 decimal places
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // Space between GPA and subject list
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Add space between widgets
            children: [
              Text(
                "List of Subjects",
                style: blackColorTextStyle.copyWith(
                  fontSize: 18,
                  color: Color.fromRGBO(13, 49, 70, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E70A0), // Background color for the filter
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: Row(
                  children: [
                    Text(
                      "Filter Year/Semester",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4), // Space between text and icon
                    const Icon(
                      Icons.filter_list, // Filter icon
                      color: Colors.white, // Icon color
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildGradeItem("Mathematics", "82"),
                _buildGradeItem("Science", "91"),
                _buildGradeItem("History", "100"),
                _buildGradeItem("Physical Education", "80"),
                _buildGradeItem("Art", "19"),
                _buildGradeItem("English", "100"),
                _buildGradeItem("Arabic", "100"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Calculate GPA from grades
  double _calculateGPA(List<int> grades) {
    if (grades.isEmpty) return 0.0; // Return 0 if there are no grades
    double total = grades.reduce((a, b) => a + b).toDouble(); // Sum of grades
    return total / grades.length; // Return average
  }

  // Helper function to build individual grade items
  Widget _buildGradeItem(String subject, String grade) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D3146), // Background color
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      padding: const EdgeInsets.all(3.0), // Padding for each subject
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin for separation
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject, style: const TextStyle(fontSize: 18, color: Colors.white)), // Subject name
          // Circular container for the grade
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E70A0), // Circle color
              shape: BoxShape.circle, // Make it circular
            ),
            padding: const EdgeInsets.all(8.0), // Padding inside the circle
            child: Text(
              grade,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Grade text
            ),
          ),
        ],
      ),
    );
  }
}

  // Helper function to build individual grade items
  Widget _buildGradeItem(String subject, String grade) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D3146), // Background color
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      padding: const EdgeInsets.all(3.0), // Padding for each subject
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin for separation
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject, style: const TextStyle(fontSize: 18, color: Colors.white)), // Subject name
          // Circular container for the grade
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E70A0), // Circle color
              shape: BoxShape.circle, // Make it circular
            ),
            padding: const EdgeInsets.all(8.0), // Padding inside the circle
            child: Text(
              grade,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Grade text
            ),
          ),
        ],
      ),
    );
  }



class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40); // Start from the bottom-left corner
    path.quadraticBezierTo(0, size.height, 40, size.height); // Left corner curve
    path.lineTo(size.width - 40, size.height); // Straight line at the bottom middle
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 40); // Right corner curve
    path.lineTo(size.width, 0); // Go to the top-right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // No need to reclip as the shape doesn't change dynamically
  }
}
