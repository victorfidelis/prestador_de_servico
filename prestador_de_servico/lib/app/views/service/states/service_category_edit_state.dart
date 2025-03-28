
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

abstract class ServiceCategoryEditState {}

class ServiceCategoryEditInitial extends ServiceCategoryEditState {}

class ServiceCategoryEditLoading extends ServiceCategoryEditState {}

class ServiceCategoryEditError extends ServiceCategoryEditState {
  final String? nameMessage;
  final String? genericMessage;
  
  ServiceCategoryEditError({this.nameMessage, this.genericMessage});
}

class ServiceCategoryEditValidated extends ServiceCategoryEditState {}

class ServiceCategoryEditSuccess extends ServiceCategoryEditState {
  final ServiceCategory serviceCategory;

  ServiceCategoryEditSuccess({required this.serviceCategory}); 
} 