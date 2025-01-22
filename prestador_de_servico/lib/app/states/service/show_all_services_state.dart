import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';

abstract class ShowAllServicesState {}

class ShowAllServicesInitial extends ShowAllServicesState {}

class ShowAllServicesLoading extends ShowAllServicesState {}

class ShowAllServicesError extends ShowAllServicesState {
  final String message;
  ShowAllServicesError(this.message);
}

class ShowAllServicesLoaded extends ShowAllServicesState {
  final ServicesByCategory servicesByCategory;
  final String message;

  ShowAllServicesLoaded({required this.servicesByCategory, this.message = ''});
}

class ShowAllServicesFiltered extends ShowAllServicesLoaded {
  final ServicesByCategory servicesByCategoriesFiltered;

  ShowAllServicesFiltered({required super.servicesByCategory, required this.servicesByCategoriesFiltered, super.message});
}
