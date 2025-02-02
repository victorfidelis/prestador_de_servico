import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_switch.dart';
import 'package:prestador_de_servico/app/views/service_day/widgets/opening_hours_card.dart';

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

  TextEditingController openingController = TextEditingController();
  FocusNode openingNode = FocusNode();

  TextEditingController closingController = TextEditingController();
  FocusNode closingNode = FocusNode();

  @override
  void initState() {
    serviceDay = widget.serviceDay;
    loadTime();
    openingNode.addListener(_onOpeningFocusChanged);
    closingNode.addListener(_onClosingFocusChanged);
    super.initState();
  }

  @override
  void dispose() {
    openingController.dispose();
    openingNode.dispose();
    closingController.dispose();
    closingNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        serviceDay.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: CustomSwitch(
                          initialValue: serviceDay.isActive,
                          onChanged: _onCheckChanged,
                        ),
                      ),
                    ),
                  ],
                ),
                serviceDay.isActive ? const SizedBox(height: 12) : Container(),
                serviceDay.isActive
                    ? OpeningHoursCard(
                        openingController: openingController,
                        closingController: closingController,
                        openingNode: openingNode,
                        closingNode: closingNode,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _onCheckChanged() {
    serviceDay = serviceDay.copyWith(isActive: !serviceDay.isActive);
    widget.changeStateOfServiceDay(serviceDay: serviceDay);
    setState(() {});
  }

  void loadTime() {
    String openingHour = serviceDay.openingHour.toString().padLeft(2, '0');
    String openingMinute = serviceDay.openingMinute.toString().padLeft(2, '0');
    openingController.text = '$openingHour:$openingMinute';
    String closingHour = serviceDay.closingHour.toString().padLeft(2, '0');
    String closingMinute = serviceDay.closingMinute.toString().padLeft(2, '0');
    closingController.text = '$closingHour:$closingMinute';
  }

  void _onOpeningFocusChanged() {
    if (openingNode.hasFocus) {
      _selectOpeningTimeText();
    } else {
      _saveOpeningTime();
    }
  }

  void _saveOpeningTime() {
    final time = _formatTime(openingController.text);
    openingController.text = time;
    serviceDay = serviceDay.copyWith(openingHour: _getHour(time), openingMinute: _getMinute(time));
    widget.changeStateOfServiceDay(serviceDay: serviceDay);
    setState(() {});
  }

  void _selectOpeningTimeText() {
    openingController.selection = TextSelection(baseOffset: 0, extentOffset: openingController.text.length);
  }

  void _onClosingFocusChanged() {
    if (closingNode.hasFocus) {
      _selectClosingTimeText();
    } else {
      _saveClosingTime();
    }
  }

  void _saveClosingTime() {
    final time = _formatTime(closingController.text);
    closingController.text = time;
    serviceDay = serviceDay.copyWith(closingHour: _getHour(time), closingMinute: _getMinute(time));
    widget.changeStateOfServiceDay(serviceDay: serviceDay);
    setState(() {});
  }

  void _selectClosingTimeText() {
    closingController.selection = TextSelection(baseOffset: 0, extentOffset: closingController.text.length);
  }

  String _formatTime(String time) {
    String formatTime = '';
    for (int i = 0; i < 5; i++) {
      if (i == 2) {
        formatTime += ':';
      } else if (i < time.length) {
        formatTime += time[i];
      } else {
        formatTime += '0';
      }
    }
    return formatTime;
  }

  int _getHour(String time) {
    return int.parse(time.substring(0, 2));
  }

  int _getMinute(String time) {
    return int.parse(time.substring(3, 5));
  }
}
