import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/states/navigation/navigation_state.dart';

class NavigationController extends ChangeNotifier{

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