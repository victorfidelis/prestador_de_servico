import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/client/client_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/views/client/state/client_state.dart';

class ClientViewModel extends ChangeNotifier {
  final ClientService clientService;

  ClientViewModel({required this.clientService});

  ClientState _state = ClientInitial();
  ClientState get state => _state;
  void _emitState(ClientState currentState) {
    _state = currentState;
    notifyListeners();
  }
  
  Future<void> load() async {
    _emitState(ClientLoading());

    final getClientsEither = await clientService.getClients();
    if (getClientsEither.isLeft) {
      _emitState(ClientError(getClientsEither.left!.message));
      return;
    }

    _emitState(ClientLoaded(clients: getClientsEither.right!));
  }
} 