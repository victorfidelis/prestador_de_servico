import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';

abstract class ServiceCategoryState {}

class ServiceCategoryInitial extends ServiceCategoryState {}

class ServiceCategoryLoading extends ServiceCategoryState {}

class ServiceCategoryError extends ServiceCategoryState {
  final String message;
  ServiceCategoryError({required this.message});
}

class ServiceCategoryLoaded extends ServiceCategoryState {
  final List<ServiceCategoryModel> serviceCategories;

  ServiceCategoryLoaded({required this.serviceCategories});
} 