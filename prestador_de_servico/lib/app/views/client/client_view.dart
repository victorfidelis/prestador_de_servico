import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/client/client_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/client/state/client_state.dart';
import 'package:prestador_de_servico/app/views/client/viewmodel/client_viewmodel.dart';
import 'package:provider/provider.dart';

class ClientView extends StatefulWidget {
  const ClientView({super.key});

  @override
  State<ClientView> createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  late final ClientViewModel clientViewModel;

  @override
  void initState() {
    clientViewModel = ClientViewModel(clientService: context.read<ClientService>());
    WidgetsBinding.instance.addPostFrameCallback((_) => clientViewModel.load());
    super.initState();
  }

  @override
  void dispose() {
    clientViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverFloatingHeader(child: CustomHeader(title: 'Clientes')),
          ListenableBuilder(
            listenable: clientViewModel,
            builder: (context, _) {
              if (clientViewModel.state is ClientInitial) {
                return const SliverFillRemaining();
              }

              if (clientViewModel.state is ClientError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((clientViewModel.state as ClientError).message),
                  ),
                );
              }

              if (clientViewModel.state is ClientLoading) {
                return SliverFillRemaining(
                  child: Container(
                    padding: const EdgeInsets.only(top: 28),
                    child: const Center(child: CustomLoading()),
                  ),
                );
              }

              final clients = (clientViewModel.state as ClientLoaded).clients;

              if (clients.isEmpty) {
                return const SliverFillRemaining(child: CustomEmptyList(label: 'Nenhum pagamento pendente'));
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                sliver: SliverList.builder(
                  itemCount: clients.length + 1,
                  itemBuilder: (context, index) {
                    if (index == clients.length) {
                      return const SizedBox(height: 150);
                    }

                    return Text(clients[index].fullname);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
