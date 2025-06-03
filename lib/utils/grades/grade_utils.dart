// utils/grade_utils.dart
import 'package:flutter/material.dart';
import 'package:project_aedp/constants/grades/grade_constants.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/models/grade/grade_model.dart';

class GradeUtils {
  /// Determines grade level characteristics based on grade class
  GradeLevel determineGradeLevel(String gradeClass) {
    int grade = int.tryParse(gradeClass.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    bool isPrimary = grade >= GradeConstants.primaryMinGrade && grade <= GradeConstants.primaryMaxGrade;
    bool isSecondary = grade >= GradeConstants.secondaryMinGrade && grade <= GradeConstants.secondaryMaxGrade;
    
    return GradeLevel(
      isPrimary: isPrimary,
      isSecondary: isSecondary,
      coefficient: isPrimary ? GradeConstants.primaryCoefficient : GradeConstants.secondaryCoefficient,
      periodCount: isPrimary ? GradeConstants.primaryPeriodCount : GradeConstants.secondaryPeriodCount,
    );
  }

  /// Gets exam type based on tab index
  String getExamType(int index) {
    switch (index) {
      case 0:
        return GradeConstants.firstPeriod;
      case 1:
        return GradeConstants.secondPeriod;
      case 2:
        return GradeConstants.thirdPeriod;
      default:
        return GradeConstants.firstPeriod;
    }
  }

  /// Validates all grades in the controllers
  String? validateGrades(Map<String, TextEditingController> controllers, BuildContext context) {
    for (var entry in controllers.entries) {
      final gradeValue = entry.value.text;
      if (gradeValue.isNotEmpty) {
        final grade = int.tryParse(gradeValue);
        if (grade == null || grade < GradeConstants.minGrade || grade > GradeConstants.maxGrade) {
          return '${S.of(context).gradeValidation} (${GradeConstants.minGrade}-${GradeConstants.maxGrade})';
        }
      }
    }
    return null;
  }

  /// Validates a single grade value
  bool isValidGrade(String gradeValue) {
    final grade = int.tryParse(gradeValue);
    return grade != null && grade >= GradeConstants.minGrade && grade <= GradeConstants.maxGrade;
  }

  /// Formats grade value for display
  String formatGrade(String gradeValue) {
    final grade = int.tryParse(gradeValue);
    if (grade == null) return gradeValue;
    return grade.toString();
  }

  /// Gets grade status color based on grade value
  Color getGradeStatusColor(String gradeValue) {
    final grade = int.tryParse(gradeValue);
    if (grade == null) return Colors.grey;
    
    if (grade >= 16) return const Color(GradeConstants.successColor); // Excellent
    if (grade >= 12) return const Color(GradeConstants.warningColor); // Good
    return const Color(GradeConstants.errorColor); // Needs improvement
  }

  /// Gets appropriate icon for grade status
  IconData getGradeStatusIcon(String gradeValue) {
    final grade = int.tryParse(gradeValue);
    if (grade == null) return Icons.help_outline;
    
    if (grade >= 16) return Icons.star; // Excellent
    if (grade >= 12) return Icons.thumb_up; // Good
    return Icons.warning; // Needs improvement
  }

  /// Calculates average grade
  double calculateAverage(List<String> grades) {
    final validGrades = grades
        .map((g) => int.tryParse(g))
        .where((g) => g != null)
        .cast<int>()
        .toList();
    
    if (validGrades.isEmpty) return 0.0;
    
    return validGrades.reduce((a, b) => a + b) / validGrades.length;
  }

  /// Gets period display name
  String getPeriodDisplayName(String examType, BuildContext context) {
    switch (examType) {
      case GradeConstants.firstPeriod:
        return S.of(context).firstPeriod;
      case GradeConstants.secondPeriod:
        return S.of(context).secondPeriod;
      case GradeConstants.thirdPeriod:
        return S.of(context).thirdPeriod;
      default:
        return examType;
    }
  }
}