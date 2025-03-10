import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';

class EditScheduledServicesViewmodel extends ChangeNotifier {
  ServiceScheduling serviceScheduling;

  EditScheduledServicesViewmodel({required this.serviceScheduling});
}