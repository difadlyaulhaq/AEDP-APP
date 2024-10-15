import 'package:flutter/material.dart';
import 'package:project_aedp/theme/theme.dart';

class DashboardStudents extends StatefulWidget {
  const DashboardStudents({super.key});

  @override
  State<DashboardStudents> createState() => _DashboardStudentsState();
}

class _DashboardStudentsState extends State<DashboardStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HOMEPAGE STUDENTS",style: blackColorTextStyle,),
      ),
    );
  }
}