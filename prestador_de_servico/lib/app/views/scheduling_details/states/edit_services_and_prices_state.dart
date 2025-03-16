abstract class EditServicesAndPricesState {}

class EditServicesAndPricesInitial extends EditServicesAndPricesState {}

class EditServicesAndPricesLoading extends EditServicesAndPricesState {}

class EditServicesAndPricesUpdateSuccess extends EditServicesAndPricesState {
  EditServicesAndPricesUpdateSuccess();
}

class EditServicesAndPricesError extends EditServicesAndPricesState {
  final String message;

  EditServicesAndPricesError({required this.message});
}

