import 'package:flutter/material.dart';

class SchedulingButton extends StatefulWidget {
  const SchedulingButton({super.key});

  @override
  State<SchedulingButton> createState() => _SchedulingButtonState();
}

class _SchedulingButtonState extends State<SchedulingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            offset: const Offset(0, 4),
            blurStyle: BlurStyle.normal,
            blurRadius: 4,
          )
        ],
      ),
      child: const Column(
        children: [
          Icon(
            Icons.calendar_month,
            size: 40,
          ),
          SizedBox(height: 4),
          Text('Agenda')
        ],
      ),
    );
  }
}
