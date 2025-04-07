import 'package:flutter/material.dart';

class ReviewStars extends StatefulWidget {
  const ReviewStars({
    super.key,
    this.review = 0,
    this.onMark,
    this.allowSetState = true,
  });

  final int review;
  final Function(int)? onMark;
  final bool allowSetState;

  @override
  State<ReviewStars> createState() => _ReviewStarsState();
}

class _ReviewStarsState extends State<ReviewStars> {
  late int review;

  @override
  void initState() {
    review = widget.review;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 28,
      children: [
        star(1),
        star(2),
        star(3),
        star(4),
        star(5),
      ],
    );
  }

  Widget star(int number) {
    const lightStar = 'assets/images/light_star.png';
    const emptyStar = 'assets/images/empty_star.png';

    return GestureDetector(
      onTap: () {
        if (widget.onMark != null) {
          widget.onMark!(number);
        }
        if (widget.allowSetState) {
          setState(() {
            review = number;
          });
        }
      },
      child: Image.asset(review >= number ? lightStar : emptyStar),
    );
  }
}
