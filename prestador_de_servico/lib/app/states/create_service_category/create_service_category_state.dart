
abstract class CreateServiceCategoryState {}

class CreateServiceCategoryInitial extends CreateServiceCategoryState {}

class CreateServiceCategoryError extends CreateServiceCategoryState {
  final String message;
  CreateServiceCategoryError({required this.message});
}

class CreateServiceCategorySuccess extends CreateServiceCategoryState {} 