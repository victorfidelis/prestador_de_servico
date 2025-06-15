import 'package:flutter/material.dart';

class SmallCustomButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final IconData? icon;

  const SmallCustomButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon == null
                ? const SizedBox()
                : Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            icon == null
                ? const SizedBox()
                : const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
