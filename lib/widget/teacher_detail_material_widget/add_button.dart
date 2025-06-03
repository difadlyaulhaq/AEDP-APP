// widgets/add_material_button.dart
import 'package:flutter/material.dart';

class AddMaterialButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddMaterialButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(
          Icons.add_circle,
          color: Color.fromRGBO(30, 113, 162, 1),
          size: 32,
        ),
        onPressed: onPressed,
      ),
    );
  }
}