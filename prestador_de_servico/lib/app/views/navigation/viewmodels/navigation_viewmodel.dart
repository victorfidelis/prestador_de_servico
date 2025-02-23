import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/navigation/states/navigation_state.dart';

class NavigationViewModel extends ChangeNotifier{

  NavigationState _state = HomeNavigationPage();
  NavigationState get state => _state;
  void _emitState({required NavigationState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  void changePage({required NavigationState navigationState}) {
    _emitState(currentState: navigationState);
  }
}