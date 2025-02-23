import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/time_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_filed_underline.dart';

class OpeningHoursCard extends StatelessWidget {
  const OpeningHoursCard({
    super.key,
    required this.openingController,
    required this.closingController,
    required this.openingNode,
    required this.closingNode,
  });

  final TextEditingController openingController;
  final FocusNode openingNode;

  final TextEditingController closingController;
  final FocusNode closingNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Horário de funcionamento'),
        Row(
          children: [
            const Text('Das'),
            const SizedBox(width: 4),
            Expanded(
              child: CustomTextFieldUnderline(
                controller: openingController,
                focusNode: openingNode,
                inputFormatters: [TimeTextInputFormatter()],
              ),
            ),
            const SizedBox(width: 4),
            const Text('Até'),
            const SizedBox(width: 4),
            Expanded(
              child: CustomTextFieldUnderline(
                controller: closingController,
                focusNode: closingNode,
                inputFormatters: [TimeTextInputFormatter()],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
