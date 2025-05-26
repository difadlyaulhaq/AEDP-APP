import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:project_aedp/generated/l10n.dart';

class RoleDropdown extends StatelessWidget {
  final List<String> roles;
  final String selectedRole;
  final ValueChanged<String?> onChanged;

  const RoleDropdown({
    super.key,
    required this.roles,
    required this.selectedRole,
    required this.onChanged,
  });

  String getLocalizedRole(BuildContext context, String role) {
    switch (role) {
      case 'student':
        return S.of(context).role_student;
      case 'parent':
        return S.of(context).role_parent;
      case 'teacher':
        return S.of(context).role_teacher;
      default:
        return S.of(context).role_student;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textAlign = Directionality.of(context) == ui.TextDirection.rtl
        ? TextAlign.right
        : TextAlign.left;

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
      ),
      child: DropdownButton<String>(
        value: selectedRole,
        icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
        isExpanded: true,
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.white, fontSize: 18),
        dropdownColor: Colors.white,
        onChanged: onChanged,
        items: roles.map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(
              getLocalizedRole(context, role),
              textAlign: textAlign,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }
}
