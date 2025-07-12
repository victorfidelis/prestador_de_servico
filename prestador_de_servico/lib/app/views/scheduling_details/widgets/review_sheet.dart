import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/review_stars.dart';

class ReviewSheet extends StatefulWidget {
  final int review;
  final String reviewDetails;
  final Function(int, String) onSave;
  const ReviewSheet({
    super.key,
    required this.review,
    required this.reviewDetails,
    required this.onSave,
  });

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
  late int review;
  final detailsController = TextEditingController();

  @override
  void initState() {
    review = widget.review;
    detailsController.text = widget.reviewDetails;
    super.initState();
  }

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 32),
      child: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Avalie o cliente',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          ReviewStars(
            review: widget.review,
            onMark: (number) {
              review = number;
            },
          ),
          const SizedBox(height: 50),
          CustomTextField(
            label: 'Detalhes e observações (opcional)',
            controller: detailsController,
            maxLines: 7,
          ),
          const Expanded(child: SizedBox()),
          CustomButton(
            label: 'Avaliar',
            onTap: () => widget.onSave(
              review,
              detailsController.text.trim(),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
