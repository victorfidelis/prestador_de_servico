import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';

abstract class ShowAllServicesState {}

class ShowAllServicesInitial extends ShowAllServicesState {}

class ShowAllServicesLoading extends ShowAllServicesState {}

class ShowAllServicesError extends ShowAllServicesState {
  final String message;
  ShowAllServicesError(this.message);
}

class ShowAllServicesLoaded extends ShowAllServicesState {
  final ServicesByCategory servicesByCategories;
  final String message;

  ShowAllServicesLoaded({required this.servicesByCategories, this.message = ''});
}

class ShowAllServicesFiltered extends ShowAllServicesLoaded {
  final ServicesByCategory servicesByCategoriesFiltered;

  ShowAllServicesFiltered({required super.servicesByCategories, required this.servicesByCategoriesFiltered, super.message});
}
