import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/menu/widgets/custom_menu_item.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu'),),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            CustomMenuItem(
              label: 'Serviços',
              icon: Icons.handyman_outlined,
              onTap: () {
                Navigator.of(context).pushNamed('/service');
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.shadow,
            ),
            CustomMenuItem(
              label: 'Dias de atendimento',
              icon: Icons.view_week_outlined,
              onTap: () {
                Navigator.of(context).pushNamed('/serviceDay');
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.shadow,
            ),
            CustomMenuItem(
              label: 'Formas de pagamento',
              icon: Icons.payments,
              onTap: () {
                Navigator.of(context).pushNamed('/payment');
              },
            ),
            Divider(
              color: Theme.of(context).colorScheme.shadow,
            ),
            CustomMenuItem(
              label: 'Agenda',
              icon: Icons.view_agenda_outlined,
              onTap: () {
                Navigator.of(context).pushNamed('/scheduling');
              },
            ),
          ],
        ),
      ),
    );
  }
}
