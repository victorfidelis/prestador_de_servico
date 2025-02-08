import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/service_scheduling/service_scheduling_service.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/service_scheduling_state.dart';

class ServiceSchedulingController extends ChangeNotifier {
  final ServiceSchedulingService serviceSchedulingService;

  ServiceSchedulingState _state = ServiceSchedulingInitial();
  ServiceSchedulingState get state => _state;
  void _emitState(ServiceSchedulingState currentState) {
    _state = currentState;
    notifyListeners();
  }

  void _changeState(ServiceSchedulingState currentState) {
    _state = currentState;
  }

  ServiceSchedulingController({required this.serviceSchedulingService}); 

  
}
