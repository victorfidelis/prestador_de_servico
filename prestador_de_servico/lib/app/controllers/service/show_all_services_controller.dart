import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/states/service/show_all_services_state.dart';
import 'package:replace_diacritic/replace_diacritic.dart';

class ShowAllServicesController extends ChangeNotifier {
  final ServiceService serviceService;

  ShowAllServicesState _state = ShowAllServicesInitial();
  ShowAllServicesState get state => _state;
  void _changeState(ShowAllServicesState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ShowAllServicesController({required this.serviceService});

  void setServicesByCategory({required ServicesByCategory servicesByCategory}) {
    _changeState(ShowAllServicesLoaded(servicesByCategories: servicesByCategory));
  }

  void init() {
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

      _changeState(
        ShowAllServicesLoaded(
          servicesByCategories: currentState.servicesByCategories,
          message: message,
        ),
      );
    } else {
      _changeState(ShowAllServicesError(message));
    }
  }

  void filter({required String textFilter}) {
    if (state is! ShowAllServicesLoaded) {
      return;
    }

    final currentState = (state as ShowAllServicesLoaded);

    final textFilterWithoutDiacricts = replaceDiacritic(textFilter);
    final List<Service> servicesFiltered = currentState.servicesByCategories.services
        .where(
          (service) => service.nameWithoutDiacritics.toLowerCase().contains(
                textFilterWithoutDiacricts.toLowerCase(),
              ),
        )
        .toList();

    final nextState = ShowAllServicesFiltered(
      servicesByCategories: currentState.servicesByCategories,
      servicesByCategoriesFiltered: currentState.servicesByCategories.copyWith(services: servicesFiltered),
    );

    _changeState(nextState);
  }
}
