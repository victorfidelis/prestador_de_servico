import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/edit_services_and_prices_state.dart';

class EditScheduledServicesViewmodel extends ChangeNotifier {
  final SchedulingService schedulingService;
  Scheduling scheduling;
  late List<ScheduledService> scheduledServicesOriginal;
  String? discountError;

  EditServicesAndPricesState _state = EditServicesAndPricesInitial();
  EditServicesAndPricesState get state => _state;
  void _emitState(EditServicesAndPricesState currentState) {
    _state = currentState;
    notifyListeners();
  }

  EditScheduledServicesViewmodel({
    required this.schedulingService,
    required this.scheduling,
  }) {
    scheduledServicesOriginal = List.from(scheduling.services);
  }

  void removeService({required int index}) {
    final service = scheduling.services[index];

    if (scheduledServicesOriginal.contains(service)) {
      scheduling.services[index] = service.copyWith(removed: true);
    } else {
      scheduling.services.remove(service);
    }

    scheduling = scheduling.copyWith(
      totalPrice: scheduling.totalPrice - service.price,
    );

    notifyListeners();
  }

  void returnService({required int index}) {
    final service = scheduling.services[index];

    scheduling.services[index] = service.copyWith(removed: false);
    scheduling = scheduling.copyWith(
      totalPrice: scheduling.totalPrice + service.price,
    );
    notifyListeners();
  }

  void addService({required Service service}) {
    ScheduledService scheduledService = ScheduledService(
      scheduledServiceId: getNextScheduledServiceId(),
      id: service.id,
      serviceCategoryId: service.serviceCategoryId,
      name: service.name,
      price: service.price,
      hours: service.hours,
      minutes: service.minutes,
      imageUrl: service.imageUrl,
      isAdditional: true,
      removed: false,
    );

    scheduling.services.add(scheduledService);
    scheduling = scheduling.copyWith(
      totalPrice: scheduling.totalPrice + service.price,
    );
    notifyListeners();
  }

  void changeRate(double rate) {
    scheduling = scheduling.copyWith(totalRate: rate);
    notifyListeners();
  }

  void changeDicount(double discount) {
    scheduling = scheduling.copyWith(totalDiscount: discount);
    notifyListeners();
  }

  int quantityOfActiveServices() {
    return scheduling.services.where((s) => !s.removed).length;
  }

  bool validateSave() {
    if (scheduling.totalPriceCalculated < 0) {
      discountError = 'Informe um valor válido';
      notifyListeners();
      return false;
    }

    return true;
  }

  int getNextScheduledServiceId() {
    return 1 +
        scheduling.services
            .map((s) => s.scheduledServiceId)
            .reduce((id1, id2) => id1 > id2 ? id1 : id2);
  }

  Future<void> save() async {
    _emitState(EditServicesAndPricesLoading());

    scheduling = scheduling.copyWith(
      endDateAndTime: schedulingService.calculateEndDate(
        scheduling.services,
        scheduling.startDateAndTime,
      ),
    );

    final editEither = await schedulingService.editServicesAndPricesOfScheduling(
      schedulingId: scheduling.id,
      totalRate: scheduling.totalRate,
      totalDiscount: scheduling.totalDiscount,
      totalPrice: scheduling.totalPrice,
      scheduledServices: scheduling.services,
      newEndDate: scheduling.endDateAndTime,
    );

    if (editEither.isLeft) {
      _emitState(EditServicesAndPricesError(message: editEither.left!.message));
    } else {
      _emitState(EditServicesAndPricesUpdateSuccess());
    }
  }
}
