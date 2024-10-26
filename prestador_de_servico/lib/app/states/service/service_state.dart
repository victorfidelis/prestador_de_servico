import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';

abstract class ServiceState {}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceError extends ServiceState {
  final String message;
  ServiceError(this.message);
}

class ServiceLoaded extends ServiceState {
  final List<ServicesByCategory> servicesByCategory;

  ServiceLoaded(this.servicesByCategory);
} 

class ServiceFiltered extends ServiceState {
  final List<ServicesByCategory> servicesByCategory;

  ServiceFiltered(this.servicesByCategory);
} 