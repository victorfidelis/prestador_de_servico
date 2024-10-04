import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

abstract class ServiceCategoryState {}

class ServiceCategoryInitial extends ServiceCategoryState {}

class ServiceCategoryLoading extends ServiceCategoryState {}

class ServiceCategoryError extends ServiceCategoryState {
  final String message;
  ServiceCategoryError({required this.message});
}

class ServiceCategoryLoaded extends ServiceCategoryState {
  final List<ServiceCategory> serviceCategories;

  ServiceCategoryLoaded({required this.serviceCategories});
} 