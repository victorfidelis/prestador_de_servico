import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/search_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';

class CustomSliverSearchHeader extends StatelessWidget {
  final String hintText;
  final Function(String value) onChanged;
  
  const CustomSliverSearchHeader({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        maxHeight: 76,
        minHeight: 76,
        child: Stack(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SearchTextField(
                hintText: hintText,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
