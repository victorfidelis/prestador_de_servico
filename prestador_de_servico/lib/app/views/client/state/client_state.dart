


import 'package:prestador_de_servico/app/models/user/user.dart';

abstract class ClientState {}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientError extends ClientState {
  final String message;
  ClientError(this.message);
}

class ClientLoaded extends ClientState {
  final List<User> clients;
  final String message;

  ClientLoaded({required this.clients, this.message = ''});
}
