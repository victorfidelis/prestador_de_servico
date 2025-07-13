import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/service/states/show_all_services_state.dart';
import 'package:replace_diacritic/replace_diacritic.dart';

class ShowAllServicesViewModel extends ChangeNotifier {
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

  ShowAllServicesViewModel({
    required this.serviceService,
    required ServiceCategory serviceCategory,
  }) {    
    _changeState(ShowAllServicesLoaded(serviceCategory: serviceCategory));
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
          serviceCategory: currentState.serviceCategory,
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
      serviceCategory: (state as ShowAllServicesLoaded).serviceCategory,
    );

    if (textFilter.isEmpty) {
      _emitState(stateToBack);
      return;
    }

    final textFilterWithoutDiacricts = replaceDiacritic(textFilter);
    final List<Service> servicesFiltered = stateToBack.serviceCategory.services
        .where(
          (service) => service.nameWithoutDiacritics.toLowerCase().contains(
                textFilterWithoutDiacricts.toLowerCase(),
              ),
        )
        .toList();

    final nextState = ShowAllServicesFiltered(
      serviceCategory: stateToBack.serviceCategory,
      serviceCategoryFiltered:
          stateToBack.serviceCategory.copyWith(services: servicesFiltered),
    );

    _emitState(nextState);
  }

  void refreshValuesOfState({
    required ServiceCategory serviceCategory,
    required ServiceCategory serviceCategoryFiltered,
  }) {
    if (state is! ShowAllServicesLoaded) {
      return;
    }

    if (state is ShowAllServicesFiltered) {
      _changeState(
        ShowAllServicesFiltered(
          serviceCategory: serviceCategory,
          serviceCategoryFiltered: serviceCategoryFiltered,
        ),
      );
    } else {
      _changeState(ShowAllServicesLoaded(serviceCategory: serviceCategory));
    }
  }
}
