import 'package:equatable/equatable.dart';
import 'material_model.dart';

abstract class MaterialState extends Equatable {
  const MaterialState();

  @override
  List<Object> get props => [];
}

class MaterialLoading extends MaterialState {}

class MaterialLoaded extends MaterialState {
  final List<MaterialModel> materials;

  const MaterialLoaded(this.materials);

  @override
  List<Object> get props => [materials];
}

class MaterialError extends MaterialState {
  final String errorMessage;

  const MaterialError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
