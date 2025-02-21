import 'package:flutter/material.dart';

class CustomAppBarTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  const CustomAppBarTitle({
    super.key,
    required this.title,
    this.fontSize = 28
  });

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
