import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extensions.dart';
import 'package:prestador_de_servico/app/states/service/show_all_services_state.dart';
import 'package:replace_diacritic/replace_diacritic.dart';

class ShowAllServicesController extends ChangeNotifier {
  final ServiceService serviceService;

  ShowAllServicesState _state = ShowAllServicesInitial();
  ShowAllServicesState get state => _state;
  void _emitState(ShowAllServicesState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(ShowAllServicesState currentState) {
    _state = currentState;
  }

  ShowAllServicesController({required this.serviceService});

  void setServicesByCategory({required ServicesByCategory servicesByCategory}) {
    _emitState(ShowAllServicesLoaded(servicesByCategory: servicesByCategory));
  }

  void init() {
    _state = ShowAllServicesInitial();
  }

  void exit() {
    _state = ShowAllServicesInitial();
  }

  Future<void> delete({required Service service}) async {
    final deleteEither = await serviceService.delete(service: service);

    if (deleteEither.isRight) {
      return;
    }

    final message = deleteEither.left!.message;

    if (state is ShowAllServicesLoaded) {
      final currentState = (state as ShowAllServicesLoaded);

      _emitState(
        ShowAllServicesLoaded(
          servicesByCategory: currentState.servicesByCategory,
          message: message,
        ),
      );
    } else {
      _emitState(ShowAllServicesError(message));
    }
  }

  void filter({required String textFilter}) {
    if (state is! ShowAllServicesLoaded) {
      return;
    }

    final stateToBack = ShowAllServicesLoaded(
      servicesByCategory: (state as ShowAllServicesLoaded).servicesByCategory,
    );

    if (textFilter.isEmpty) {
      _emitState(stateToBack);
      return;
    }

    final textFilterWithoutDiacricts = replaceDiacritic(textFilter);
    final List<Service> servicesFiltered = stateToBack.servicesByCategory.services
        .where(
          (service) => service.nameWithoutDiacritics.toLowerCase().contains(
                textFilterWithoutDiacricts.toLowerCase(),
              ),
        )
        .toList();

    final nextState = ShowAllServicesFiltered(
      servicesByCategory: stateToBack.servicesByCategory,
      servicesByCategoryFiltered: stateToBack.servicesByCategory.copyWith(services: servicesFiltered),
    );

    _emitState(nextState);
  }

  void refreshValuesOfState({
    required ServicesByCategory servicesByCategory,
    required ServicesByCategory servicesByCategoryFiltered,
  }) {
    if (state is! ShowAllServicesLoaded) {
      return;
    }

    if (state is ShowAllServicesFiltered) {
      _changeState(
        ShowAllServicesFiltered(
          servicesByCategory: servicesByCategory,
          servicesByCategoryFiltered: servicesByCategoryFiltered,
        ),
      );
    } else  {
      _changeState(ShowAllServicesLoaded(servicesByCategory: servicesByCategory));
    }
  }
}
