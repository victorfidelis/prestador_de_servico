import 'package:flutter/material.dart';

class CustomWhiteButtom extends StatefulWidget {
  final String label;
  final Color textColor;
  final Function() onTap;
  const CustomWhiteButtom({
    super.key,
    required this.label,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<CustomWhiteButtom> createState() => _CustomWhiteButtomState();
}

class _CustomWhiteButtomState extends State<CustomWhiteButtom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            offset: const Offset(0, 4),
            blurStyle: BlurStyle.normal,
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: widget.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
