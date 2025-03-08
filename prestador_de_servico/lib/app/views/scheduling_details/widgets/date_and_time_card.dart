import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/edit_button.dart';

class DateAndTimeCard extends StatefulWidget {
  final DateTime? oldStartDateAndTime;
  final DateTime? oldEndDateAndTime;
  final DateTime startDateAndTime;
  final DateTime endDateAndTime;
  final Function()? onEdit;

  const DateAndTimeCard({
    super.key,
    this.oldStartDateAndTime,
    this.oldEndDateAndTime,
    required this.startDateAndTime,
    required this.endDateAndTime,
    this.onEdit,
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
              hasOldDate
                  ? const Text(
                      'Data trocada',
                      style: TextStyle(fontSize: 16),
                    )
                  : const SizedBox(),
              hasOldDate ? card(oldStartDateAndTime!, oldEndDateAndTime!) : const SizedBox(),
              Text(
                'Data do serviço',
                style: TextStyle(
                  fontSize: 16,
                  color: hasOldDate ? const Color(0xff1976D2) : Colors.black,
                ),
              ),
              card(startDateAndTime, endDateAndTime, hasOldDate),
            ],
          ),
        ),
        hasEditButtom ? EditButton(onTap: widget.onEdit!) : const SizedBox(),
      ],
    );
  }

  Widget card(DateTime startDateAndTime, DateTime endDateAndTime, [bool newDate = false]) {
    final Color textColor;
    if (newDate) {
      textColor = const Color(0xff1976D2);
    } else {
      textColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20),
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
                style: TextStyle(fontSize: 14, color: textColor),
              ),
              const SizedBox(width: 6),
              Text(
                Formatters.defaultFormatHoursAndMinutes(
                  startDateAndTime.hour,
                  startDateAndTime.minute,
                ),
                style: TextStyle(fontSize: 18, color: textColor),
              ),
              const SizedBox(width: 6),
              Text(
                'às',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(width: 6),
              Text(
                Formatters.defaultFormatHoursAndMinutes(
                  endDateAndTime.hour,
                  endDateAndTime.minute,
                ),
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
