import 'package:flutter/material.dart';

class CustomTypeCalendar extends StatelessWidget {
  final Function() onPressed;
  final IconData iconData;
  final String label;

  const CustomTypeCalendar({
    super.key,
    required this.onPressed,
    required this.iconData,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: 180,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 60,
              child: Icon(
                iconData,
                size: 32,
              ),
            ),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
