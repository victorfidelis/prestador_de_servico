import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final double height;
  const CustomHeader({super.key, required this.title, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.shadow, offset: const Offset(0, 4), blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 60, child: BackNavigation(onTap: () => Navigator.pop(context))),
          Expanded(
            child: CustomAppBarTitle(title: title),
          ),
          const SizedBox(width: 60),
        ],
      ),
    );
  }
}
