import 'package:flutter/material.dart';

class BackNavigation extends StatelessWidget {
  final Function() onTap;

  const BackNavigation({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.arrow_back_ios,
        ),
      ),
    );
  }
}
