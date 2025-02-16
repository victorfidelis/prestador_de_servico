import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/scheduling/days_controller.dart';
import 'package:prestador_de_servico/app/states/service_scheduling/days_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_type_calendar.dart';
import 'package:provider/provider.dart';

class CustomMenuCalendarType extends StatelessWidget {
  CustomMenuCalendarType({super.key});

  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      builder: (context, controller, _) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.menu_outlined),
        );
      },
      menuChildren: [
        CustomTypeCalendar(
          onPressed: () {
            _menuController.close();
            context.read<DaysController>().changeTypeView(TypeView.main);
          },
          iconData: Icons.view_agenda_outlined,
          label: 'Principal',
        ),
        CustomTypeCalendar(
          onPressed: () {
            _menuController.close();
            context.read<DaysController>().changeTypeView(TypeView.mount);
          },
          iconData: Icons.calendar_month,
          label: 'Mês',
        ),
      ],
    );
  }
}
