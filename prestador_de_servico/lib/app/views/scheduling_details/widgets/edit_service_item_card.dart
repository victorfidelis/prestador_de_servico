import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduled_service/scheduled_service.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';

class EditServiceItemCard extends StatefulWidget {
  final ScheduledService service;
  final int index;
  final Function(int) onLongPress;
  
  const EditServiceItemCard({
    super.key,
    required this.service,
    required this.index,
    required this.onLongPress,
  });

  @override
  State<EditServiceItemCard> createState() => _EditServiceItemCardState();
}

class _EditServiceItemCardState extends State<EditServiceItemCard> {
  late ScheduledService service;

  @override
  void initState() {
    service = widget.service;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatPrice = DataConverter.formatPrice(service.price);

    Color backColor;
    if (service.removed) {
      backColor = const Color(0xffEF9A9A);
    } else if (service.isAdditional) {
      backColor = const Color(0xffC8E6C9);
    } else {
      backColor = Colors.white;
    }

    return GestureDetector(
      onLongPress: () => widget.onLongPress(widget.index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backColor,
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
        child: Row(
          children: [Expanded(child: Text(service.name)), Text(formatPrice)],
        ),
      ),
    );
  }
}
