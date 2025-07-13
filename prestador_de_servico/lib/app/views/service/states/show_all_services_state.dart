import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

abstract class ShowAllServicesState {}

class ShowAllServicesInitial extends ShowAllServicesState {}

class ShowAllServicesLoading extends ShowAllServicesState {}

class ShowAllServicesError extends ShowAllServicesState {
  final String message;
  ShowAllServicesError(this.message);
}

class ShowAllServicesLoaded extends ShowAllServicesState {
  final ServiceCategory serviceCategory;
  final String message;

  ShowAllServicesLoaded({required this.serviceCategory, this.message = ''});
}

class ShowAllServicesFiltered extends ShowAllServicesLoaded {
  final ServiceCategory serviceCategoryFiltered;

  ShowAllServicesFiltered({required super.serviceCategory, required this.serviceCategoryFiltered, super.message});
}
