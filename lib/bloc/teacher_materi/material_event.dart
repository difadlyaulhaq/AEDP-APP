import 'package:equatable/equatable.dart';
import 'material_model.dart';

abstract class MaterialEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMaterials extends MaterialEvent {
  final List<String> subjects; 

  FetchMaterials({required this.subjects});

  @override
  List<Object?> get props => [subjects];
}


class AddMaterial extends MaterialEvent {
  final MaterialModel material;

  AddMaterial(this.material);

  @override
  List<Object?> get props => [material];
}
