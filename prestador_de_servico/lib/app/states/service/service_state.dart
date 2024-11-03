import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';

abstract class ServiceState {}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
}

class ServiceLoaded extends ServiceState {
  final List<ServicesByCategory> servicesByCategories;
  final String message;

  ServiceLoaded({required this.servicesByCategories, this.message = ''});
}

class ServiceFiltered extends ServiceState {
  final List<ServicesByCategory> servicesByCategories;

  ServiceFiltered(this.servicesByCategories);
}