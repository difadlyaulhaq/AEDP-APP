// widgets/material_app_bar.dart
import 'package:flutter/material.dart';

class MaterialAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String subject;
  final VoidCallback onRefresh;

  const MaterialAppBar({
    super.key,
    required this.subject,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '$subject Materials',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(30, 113, 162, 1),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: onRefresh,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}