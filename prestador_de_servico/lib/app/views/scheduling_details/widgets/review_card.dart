import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/widgets/review_stars.dart';

class ReviewCard extends StatelessWidget {
  final String? reviewDetails;
  final int? review;
  final Function(int)? onAddOrEditReview;

  const ReviewCard({super.key, this.reviewDetails, this.review, this.onAddOrEditReview});

  bool get hasReviewDetail => reviewDetails != null && reviewDetails!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Avaliação do cliente',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReviewStars(
                review: review ?? 0,
                onMark: onAddOrEditReview,
                allowSetState: false,
              ),
            ],
          ),
          hasReviewDetail ? const SizedBox(height: 16) : const SizedBox(height: 8),
          hasReviewDetail
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(reviewDetails ?? ''),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
