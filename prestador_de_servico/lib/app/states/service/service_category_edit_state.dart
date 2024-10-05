
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

abstract class ServiceCategoryEditState {}

class ServiceCategoryEditInitial extends ServiceCategoryEditState {}

class ServiceCategoryEditAdd extends ServiceCategoryEditState {}

class ServiceCategoryEditUpdate extends ServiceCategoryEditState {
  final ServiceCategory serviceCategory;
  ServiceCategoryEditUpdate({required this.serviceCategory});
}

class ServiceCategoryEditLoading extends ServiceCategoryEditState {}

class ServiceCategoryEditValidationError extends ServiceCategoryEditState {
  final String? nameMessage;
  final String? genericMessage;
  
  ServiceCategoryEditValidationError({this.nameMessage, this.genericMessage});
}

class ServiceCategoryEditSuccess extends ServiceCategoryEditState {
  final ServiceCategory serviceCategory;

  ServiceCategoryEditSuccess({required this.serviceCategory}); 
} 