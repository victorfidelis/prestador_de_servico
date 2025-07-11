import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';

class SchedulingDayTitle extends StatelessWidget {
  final DateTime date;
  const SchedulingDayTitle({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Agendamentos',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          Formatters.defaultFormatDate(date),
          style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
