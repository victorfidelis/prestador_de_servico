import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/scheduling/states/days_state.dart';
import 'package:prestador_de_servico/app/views/scheduling/widgets/custom_type_calendar.dart';

class CustomMenuCalendarType extends StatelessWidget {
  final Function(TypeView typeView) onChangeTypeView;
  CustomMenuCalendarType({
    super.key,
    required this.onChangeTypeView,
  });

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
            onChangeTypeView(TypeView.main);
          },
          iconData: Icons.view_agenda_outlined,
          label: 'Principal',
        ),
        CustomTypeCalendar(
          onPressed: () {
            _menuController.close();
            onChangeTypeView(TypeView.mount);
          },
          iconData: Icons.calendar_month,
          label: 'Mês',
        ),
      ],
    );
  }
}
