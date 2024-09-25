import 'package:flutter/material.dart';

class CustomMenuButtom extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final String? text;
  final bool isCurrent;

  const CustomMenuButtom({
    super.key,
    required this.onTap,
    required this.icon,
    this.text,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isCurrent
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isCurrent ? 32 : 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            text == null
                ? Container()
                : Text(
                    text!,
                    style: TextStyle(
                      fontSize: isCurrent ? 12 : 10,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
