import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';

class EditScheduledServicesViewmodel extends ChangeNotifier {
  ServiceScheduling serviceScheduling;

  EditScheduledServicesViewmodel({required this.serviceScheduling});

  void removeService({required int index}) {
    final service = serviceScheduling.services[index];

    serviceScheduling.services[index] = service.copyWith(removed: true);
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

  void addService({required ScheduledService service}) {
    serviceScheduling.services.add(service);
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
}
