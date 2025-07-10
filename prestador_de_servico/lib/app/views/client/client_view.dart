import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';

class ClientView extends StatefulWidget {
  const ClientView({super.key});

  @override
  State<ClientView> createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFloatingHeader(child: CustomHeader(title: 'Clientes')),
          SliverFillRemaining(
            child: Text('Clientes'),
          )
        ],
      ),
    );
  }
}
