import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/small_custom_buttom.dart';

class CustomEmptyList extends StatefulWidget {
  final String label;
  final Function()? action;
  final String labelAction;

  const CustomEmptyList({super.key, required this.label, this.action, this.labelAction = ''});

  @override
  State<CustomEmptyList> createState() => _CustomEmptyListState();
}

class _CustomEmptyListState extends State<CustomEmptyList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF757575),
              ),
              textAlign: TextAlign.center,
            ),
            _buildAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildAction() {
    if (widget.action == null) {
      return const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24),
        SmallCustomButton(label: 'Adicionar imagem', onTap: () {}, icon: Icons.add),
      ],
    );
  }
}
