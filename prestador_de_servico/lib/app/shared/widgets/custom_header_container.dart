import 'package:flutter/material.dart';

class CustomHeaderContainer extends StatelessWidget {
  final Widget child;
  final double height;
  const CustomHeaderContainer({
    super.key,
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        // boxShadow: [
        //   BoxShadow(
        //       color: Theme.of(context).colorScheme.shadow,
        //       offset: const Offset(0, 4),
        //       blurRadius: 4)
        // ],
      ),
      child: child,
    );
  }
}
