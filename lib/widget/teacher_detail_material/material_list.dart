// widgets/material_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/material_and_subject/material_model.dart';
import 'package:project_aedp/bloc/material_and_subject/material_state.dart' as teacher_material_state;
import 'package:project_aedp/bloc/material_and_subject/teacher_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'material_card.dart';

class MaterialListWidget extends StatelessWidget {
  final MaterialBloc materialBloc;

  const MaterialListWidget({
    super.key,
    required this.materialBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<MaterialBloc, teacher_material_state.MaterialState>(
        builder: (context, state) {
          if (state is teacher_material_state.MaterialLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is teacher_material_state.MaterialLoaded) {
            if (state.materials.isEmpty) {
              return const Center(
                child: Text(
                  'No materials available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.materials.length,
              itemBuilder: (context, index) {
                final material = state.materials[index];
                return MaterialCard(
                  material: material,
                  onOpenFile: () => _openFile(context, material.fileLink),
                );
              },
            );
          } else if (state is teacher_material_state.MaterialError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.errorMessage}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No materials available.'));
        },
      ),
    );
  }

  Future<void> _openFile(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open file.')),
      );
    }
  }
}