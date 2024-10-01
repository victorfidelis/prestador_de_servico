import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  const CustomText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Nova categoria',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700, 
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
