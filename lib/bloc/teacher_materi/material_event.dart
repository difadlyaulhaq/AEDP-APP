import 'package:equatable/equatable.dart';
import 'material_model.dart';

abstract class MaterialEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMaterials extends MaterialEvent {
  final String subjectId; // Fetch by subject ID

  FetchMaterials({required this.subjectId});

  @override
  List<Object?> get props => [subjectId];
}

class AddMaterial extends MaterialEvent {
  final MaterialModel material;

  AddMaterial(this.material);

  @override
  List<Object?> get props => [material];
}
