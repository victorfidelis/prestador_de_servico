import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/edit_services_and_prices_state.dart';

class EditScheduledServicesViewmodel extends ChangeNotifier {
  final SchedulingService schedulingService;
  ServiceScheduling serviceScheduling;
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
    required this.serviceScheduling,
  }) {
    scheduledServicesOriginal = List.from(serviceScheduling.services);
  }

  void removeService({required int index}) {
    final service = serviceScheduling.services[index];

    if (scheduledServicesOriginal.contains(service)) {
      serviceScheduling.services[index] = service.copyWith(removed: true);
    } else {
      serviceScheduling.services.remove(service);
    }

    serviceScheduling = serviceScheduling.copyWith(
      totalPrice: serviceScheduling.totalPrice - service.price,
    );

    notifyListeners();
  }

  void returnService({required int index}) {
    final service = serviceScheduling.services[index];

    serviceScheduling.services[index] = service.copyWith(removed: false);
    serviceScheduling = serviceScheduling.copyWith(
      totalPrice: serviceScheduling.totalPrice + service.price,
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

    serviceScheduling.services.add(scheduledService);
    serviceScheduling = serviceScheduling.copyWith(
      totalPrice: serviceScheduling.totalPrice + service.price,
    );
    notifyListeners();
  }

  void changeRate(double rate) {
    serviceScheduling = serviceScheduling.copyWith(totalRate: rate);
    notifyListeners();
  }

  void changeDicount(double discount) {
    serviceScheduling = serviceScheduling.copyWith(totalDiscount: discount);
    notifyListeners();
  }

  int quantityOfActiveServices() {
    return serviceScheduling.services.where((s) => !s.removed).length;
  }

  bool validateSave() {
    if (serviceScheduling.totalPriceCalculated < 0) {
      discountError = 'Informe um valor válido';
      notifyListeners();
      return false;
    }

    return true;
  }

  int getNextScheduledServiceId() {
    return 1 +
        serviceScheduling.services
            .map((s) => s.scheduledServiceId)
            .reduce((id1, id2) => id1 > id2 ? id1 : id2);
  }

  Future<void> save() async {
    _emitState(EditServicesAndPricesLoading());

    serviceScheduling = serviceScheduling.copyWith(
      endDateAndTime: schedulingService.calculateEndDate(
        serviceScheduling.services,
        serviceScheduling.startDateAndTime,
      ),
    );

    final editEither = await schedulingService.editServicesAndPricesOfScheduling(
      schedulingId: serviceScheduling.id,
      totalRate: serviceScheduling.totalRate,
      totalDiscount: serviceScheduling.totalDiscount,
      totalPrice: serviceScheduling.totalPrice,
      scheduledServices: serviceScheduling.services,
      newEndDate: serviceScheduling.endDateAndTime,
    );

    if (editEither.isLeft) {
      _emitState(EditServicesAndPricesError(message: editEither.left!.message));
    } else {
      _emitState(EditServicesAndPricesUpdateSuccess());
    }
  }
}
