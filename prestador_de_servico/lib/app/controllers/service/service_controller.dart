import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/states/service/service_state.dart';

class ServiceController extends ChangeNotifier {
  final ServiceCategoryService serviceCategoryService;
  final ServiceService serviceService;
  final ServicesByCategoryService servicesByCategoryService;

  ServiceState _state = ServiceInitial();
  ServiceState get state => _state;
  void _changeState(ServiceState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ServiceController({
    required this.serviceCategoryService,
    required this.serviceService,
    required this.servicesByCategoryService,
  });

  void init() {
    _state = ServiceInitial();
  }

  Future<void> load() async {
    _changeState(ServiceLoading());

    final getAllEither = await servicesByCategoryService.getAll();
    if (getAllEither.isLeft) {
      _changeState(ServiceError(getAllEither.left!.message));
      return;
    }

    _changeState(ServiceLoaded(servicesByCategories: getAllEither.right!));
  }

  Future<void> filter(String name) async {
    _changeState(ServiceLoading());

    final getByEither = await servicesByCategoryService.getByContainedName(name);
    if (getByEither.isLeft) {
      _changeState(ServiceError(getByEither.left!.message));
      return;
    }

    _changeState(ServiceFiltered(getByEither.right!));
  }

  Future<void> deleteCategory({required ServiceCategory serviceCategory}) async {
    final deleteEither = await serviceCategoryService.delete(serviceCategory: serviceCategory);

    if (deleteEither.isRight) {
      return;
    }

    _changeState(ServiceLoading());

    final message = deleteEither.left!.message;

    final getAllEither = await servicesByCategoryService.getAll();
    if (getAllEither.isLeft) {
      _changeState(ServiceError(getAllEither.left!.message));
      return;
    }

    _changeState(
      ServiceLoaded(
        servicesByCategories: getAllEither.right!,
        message: message,
      ),
    );
  }

  void addOnList({required ServiceCategory serviceCategory}) {
    if (state is! ServiceLoaded) {
      return;
    }

    // ServiceCategoryLoaded currentState = state as ServiceCategoryLoaded;
    // currentState.cards.insert(0, serviceCategory);

    // _changeState(currentState);
  }

  void updateOnList({required ServiceCategory serviceCategory}) {
    if (state is! ServiceLoaded) {
      return;
    }

    // ServiceCategoryLoaded currentState = state as ServiceCategoryLoaded;
    // int index = currentState.cards.indexWhere((element) => element.id == serviceCategory.id);
    // currentState.cards[index] = serviceCategory;

    // _changeState(currentState: currentState);
  }
}
