import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/service/states/service_state.dart';
import 'package:replace_diacritic/replace_diacritic.dart';

class ServiceViewModel extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;
  final ServiceService serviceService;
  final ServicesByCategoryService servicesByCategoryService;

  ServiceState _state = ServiceInitial();
  ServiceState get state => _state;
  void _emitState(ServiceState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(ServiceState currentState) {
    _state = currentState;
  }

  ServiceViewModel({
    required this.serviceCategoryService,
    required this.serviceService,
    required this.servicesByCategoryService,
  });

  void init() {
    _state = ServiceInitial();
  }

  Future<void> load() async {
    _emitState(ServiceLoading());

    final getAllEither = await servicesByCategoryService.getAll();
    if (getAllEither.isLeft) {
      _emitState(ServiceError(getAllEither.left!.message));
      return;
    }

    _emitState(ServiceLoaded(servicesByCategories: getAllEither.right!));
  }

  void filter({required String textFilter}) {
    if (state is! ServiceLoaded) {
      return;
    }

    final stateToBack = ServiceLoaded(
      servicesByCategories: (state as ServiceLoaded).servicesByCategories,
    );

    if (textFilter.isEmpty) {
      _emitState(stateToBack);
      return;
    }

    final textFilterWithoutDiacricts = replaceDiacritic(textFilter);
    final List<ServicesByCategory> servicesByCategoriesFiltered = stateToBack.servicesByCategories
        .where(
          (s) => s.serviceCategory.nameWithoutDiacritics.toLowerCase().contains(
                textFilterWithoutDiacricts.toLowerCase(),
              ),
        )
        .toList();

    final nextState = ServiceFiltered(
      servicesByCategories: stateToBack.servicesByCategories,
      servicesByCategoriesFiltered: servicesByCategoriesFiltered,
    );

    _emitState(nextState);
  }

  Future<void> deleteCategory({required ServiceCategory serviceCategory}) async {
    final deleteEither = await serviceCategoryService.delete(serviceCategory: serviceCategory);

    if (deleteEither.isRight) {
      return;
    }

    _emitState(ServiceLoading());

    final message = deleteEither.left!.message;

    final getAllEither = await servicesByCategoryService.getAll();
    if (getAllEither.isLeft) {
      _emitState(ServiceError(getAllEither.left!.message));
      return;
    }

    _emitState(
      ServiceLoaded(
        servicesByCategories: getAllEither.right!,
        message: message,
      ),
    );
  }

  Future<void> deleteService({required Service service}) async {
    final deleteEither = await serviceService.delete(service: service);

    if (deleteEither.isRight) {
      return;
    }

    _emitState(ServiceLoading());

    final message = deleteEither.left!.message;

    final getAllEither = await servicesByCategoryService.getAll();
    if (getAllEither.isLeft) {
      _emitState(ServiceError(getAllEither.left!.message));
      return;
    }

    _emitState(
      ServiceLoaded(
        servicesByCategories: getAllEither.right!,
        message: message,
      ),
    );
  }

  void refreshValuesOfState({
    required List<ServicesByCategory> servicesByCategories,
    required List<ServicesByCategory> servicesByCategoriesFiltered,
  }) {
    if (state is! ServiceLoaded) {
      return;
    }

    if (state is ServiceFiltered) {
      _changeState(
        ServiceFiltered(
          servicesByCategories: servicesByCategories,
          servicesByCategoriesFiltered: servicesByCategoriesFiltered,
        ),
      );
    } else  {
      _changeState(ServiceLoaded(servicesByCategories: servicesByCategories));
    }
  }
}
