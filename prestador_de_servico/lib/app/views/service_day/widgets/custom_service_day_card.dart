
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_switch.dart';

class CustomServiceDayCard extends StatefulWidget {
  final ServiceDay serviceDay;
  final Function({required ServiceDay serviceDay}) changeStateOfServiceDay;

  const CustomServiceDayCard({
    super.key,
    required this.serviceDay,
    required this.changeStateOfServiceDay,
  });

  @override
  State<CustomServiceDayCard> createState() => _CustomServiceDayCardState();
}

class _CustomServiceDayCardState extends State<CustomServiceDayCard> {

  late ServiceDay serviceDay;

  @override
  void initState() {
    serviceDay = widget.serviceDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    serviceDay.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CustomSwitch(
                      initialValue: serviceDay.isActive,
                      onChanged: onChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void onChanged() {
    serviceDay = serviceDay.copyWith(isActive: !serviceDay.isActive);
    widget.changeStateOfServiceDay(serviceDay: serviceDay);
  }
}
