
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';

abstract class ServiceCategoryEditState {}

class ServiceCategoryEditInitial extends ServiceCategoryEditState {}

class ServiceCategoryEditAdd extends ServiceCategoryEditState {}

class ServiceCategoryEditUpdate extends ServiceCategoryEditState {
  final ServiceCategoryModel serviceCategory;
  ServiceCategoryEditUpdate({required this.serviceCategory});
}

class ServiceCategoryEditLoading extends ServiceCategoryEditState {}

class ServiceCategoryEditError extends ServiceCategoryEditState {
  final String? nameMessage;
  final String? genericMessage;
  
  ServiceCategoryEditError({this.nameMessage, this.genericMessage});
}

class ServiceCategoryEditSuccess extends ServiceCategoryEditState {
  final ServiceCategoryModel serviceCategory;

  ServiceCategoryEditSuccess({required this.serviceCategory}); 
} 