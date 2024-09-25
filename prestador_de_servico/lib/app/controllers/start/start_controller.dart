import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/states/start/start_state.dart';

enum CurrentPage {home, agenda, menu}

class StartController extends ChangeNotifier{

  StartState _state = HomeStart();
  StartState get state => _state;
  void _changeState({required StartState currentState}) {
    _state = currentState;
    notifyListeners();
  }

  void changePage({required StartState startState}) {
    _changeState(currentState: startState);
  }
}