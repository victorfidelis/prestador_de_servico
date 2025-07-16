import 'package:flutter/foundation.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/services/service_day/service_day_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';

class ServiceDayViewModel extends ChangeNotifier {
  final ServiceDayService serviceDayService;
  List<ServiceDay> serviceDays = [];

  bool serviceDayLoading = false;

  String? errorMessage;
  ValueNotifier<String?> notificationMessage = ValueNotifier(null);

  ServiceDayViewModel({required this.serviceDayService});

  @override
  void dispose() {
    notificationMessage.dispose();
    super.dispose();
  }

  bool get hasError => errorMessage != null;

  void _setServiceDayLoading(bool value) {
    serviceDayLoading = value;
    notifyListeners();
  }

  void _setNotificationMessage(String value) {
    notificationMessage.value = null; // É necessário para garantir o ValueNotifier vai notificar os ouvintes
    notificationMessage.value = value;
  }

  Future<void> load() async {
    _clearErrors();
    _setServiceDayLoading(true);

    final getAllEither = await serviceDayService.getAll();
    if (getAllEither.isLeft) {
      errorMessage = getAllEither.left!.message;
    } else {
      serviceDays = getAllEither.right!;
    }

    _setServiceDayLoading(false);
  }

  Future<void> update({required ServiceDay serviceDay}) async {
    if (serviceDayLoading) {
      return;
    }

    final updateEither = await serviceDayService.update(serviceDay: serviceDay);
    if (updateEither.isRight) {
      final serviceDayIndex = serviceDays.indexWhere((s) => s.id == serviceDay.id);
      serviceDays[serviceDayIndex] = serviceDay;
      return;
    }

    _setNotificationMessage(updateEither.left!.message);
    final getAllEither = await serviceDayService.getAll();
    if (getAllEither.isLeft) {
      errorMessage = getAllEither.left!.message;
    } else {
      serviceDays = getAllEither.right!;
    }

    notifyListeners();
  }

  void _clearErrors() {
    errorMessage = null;  
  }
}
