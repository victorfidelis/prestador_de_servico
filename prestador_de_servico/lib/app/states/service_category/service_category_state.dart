import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';

abstract class ServiceCategoryState {}

class ServiceCategoryInitial extends ServiceCategoryState {}

class ServiceCategoryLoading extends ServiceCategoryState {}

class ServiceCategoryError extends ServiceCategoryState {
  final String message;
  ServiceCategoryError(this.message);
}

class ServiceCategoryLoaded extends ServiceCategoryState {
  final List<ServicesByCategory> servicesByCategory;

  ServiceCategoryLoaded(this.servicesByCategory);
} 