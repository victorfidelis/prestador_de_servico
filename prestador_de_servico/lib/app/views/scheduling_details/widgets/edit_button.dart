import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';

class EditButton extends StatefulWidget {
  final Function() onTap;
  const EditButton({super.key, required this.onTap});

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: customColors.onEdit,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(0, 4),
              blurStyle: BlurStyle.normal,
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          Icons.edit,
          color: customColors.edit,
        ),
      ),
    );
  }
}
