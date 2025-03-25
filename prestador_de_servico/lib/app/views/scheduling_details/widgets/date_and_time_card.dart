import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/edit_button.dart';

class DateAndTimeCard extends StatefulWidget {
  final DateTime? oldStartDateAndTime;
  final DateTime? oldEndDateAndTime;
  final DateTime startDateAndTime;
  final DateTime endDateAndTime;
  final Function()? onEdit;
  final bool unavailable;
  final bool inConflict;

  const DateAndTimeCard({
    super.key,
    this.oldStartDateAndTime,
    this.oldEndDateAndTime,
    required this.startDateAndTime,
    required this.endDateAndTime,
    this.onEdit,
    this.unavailable = false,
    this.inConflict = false,
  });

  @override
  State<DateAndTimeCard> createState() => _DateAndTimeCardState();
}

class _DateAndTimeCardState extends State<DateAndTimeCard> {
  late DateTime? oldStartDateAndTime;
  late DateTime? oldEndDateAndTime;
  late DateTime startDateAndTime;
  late DateTime endDateAndTime;
  late bool hasEditButtom;

  bool get hasOldDate => oldStartDateAndTime != null;

  @override
  void initState() {
    oldStartDateAndTime = widget.oldStartDateAndTime;
    oldEndDateAndTime = widget.oldEndDateAndTime;
    startDateAndTime = widget.startDateAndTime;
    endDateAndTime = widget.endDateAndTime;
    hasEditButtom = widget.onEdit != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasOldDate ? 'Nova data' : 'Data',
                style: const TextStyle(fontSize: 16),
              ),
              card(startDateAndTime, endDateAndTime),
              hasOldDate ? card(oldStartDateAndTime!, oldEndDateAndTime!, true) : const SizedBox(),
              const SizedBox(height: 8),
              message(),
            ],
          ),
        ),
        hasEditButtom ? EditButton(onTap: widget.onEdit!) : const SizedBox(),
      ],
    );
  }

  Widget card(DateTime startDateAndTime, DateTime endDateAndTime, [bool oldDate = false]) {
    Color textColor = Colors.black;
    if (oldDate) {
      textColor = Theme.of(context).extension<CustomColors>()!.cancel!;
    }

    return Opacity(
      opacity: oldDate ? 0.6 : 1.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatters.defaultFormatDate(startDateAndTime),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'das',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        Formatters.defaultFormatHoursAndMinutes(
                          startDateAndTime.hour,
                          startDateAndTime.minute,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'às',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        Formatters.defaultFormatHoursAndMinutes(
                          endDateAndTime.hour,
                          endDateAndTime.minute,
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            oldDate
                ? Positioned(
                    top: 12,
                    child: Container(
                      height: 2,
                      width: 115,
                      color: textColor,
                    ),
                  )
                : const SizedBox(),
            oldDate
                ? Positioned(
                    top: 38,
                    child: Container(
                      height: 2,
                      width: 160,
                      color: textColor,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget message() {
    Widget widgetReturn = Container();
    if (widget.unavailable) {
      widgetReturn = const Text(
        'Horário indisponível',
        style: TextStyle(
          color: Color(0xffE70000),
          fontWeight: FontWeight.w700,
        ),
      );
    } else if (widget.inConflict) {
      widgetReturn = const Text(
        'Horário em conflito',
        style: TextStyle(
          color: Color(0xffE70000),
          fontWeight: FontWeight.w700,
        ),
      );
    }
    return widgetReturn;
  }
}
