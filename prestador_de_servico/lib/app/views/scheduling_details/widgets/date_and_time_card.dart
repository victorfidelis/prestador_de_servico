import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/edit_button.dart';

class DateAndTimeCard extends StatefulWidget {
  final DateTime startDateAndTime;
  final DateTime endDateAndTime;

  const DateAndTimeCard({
    super.key,
    required this.startDateAndTime,
    required this.endDateAndTime,
  });

  @override
  State<DateAndTimeCard> createState() => _DateAndTimeCardState();
}

class _DateAndTimeCardState extends State<DateAndTimeCard> {
  late DateTime startDateAndTime;
  late DateTime endDateAndTime;

  @override
  void initState() {
    startDateAndTime = widget.startDateAndTime;
    endDateAndTime = widget.endDateAndTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data',
          style: TextStyle(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Formatters.defaultFormatDate(startDateAndTime),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'das',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    Formatters.defaultFormatHoursAndMinutes(
                      startDateAndTime.hour,
                      startDateAndTime.minute,
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'às',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    Formatters.defaultFormatHoursAndMinutes(
                      endDateAndTime.hour,
                      endDateAndTime.minute,
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              EditButton(),
            ],
          ),
        ),
      ],
    );
  }
}
