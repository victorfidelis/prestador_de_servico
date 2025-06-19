import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/animated_list_helper.dart';
import 'package:prestador_de_servico/app/shared/widgets/animated_horizontal_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/shared/widgets/image_card.dart';

class ImagesCard extends StatefulWidget {
  final List<String> images;
  final Function() onOpenAllImages;
  const ImagesCard({super.key, required this.images, required this.onOpenAllImages});

  @override
  State<ImagesCard> createState() => _ImagesCardState();
}

class _ImagesCardState extends State<ImagesCard> {
  AnimatedListHelper<String>? _imageListHelper;
  final _scrollController = ScrollController();
  late List<String> images;

  @override
  void initState() {
    images = widget.images;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Imagens',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              CustomLink(label: 'Abrir', onTap: widget.onOpenAllImages),
            ],
          ),
        ),
        const SizedBox(height: 12),
        images.isEmpty ? _buildEmptyListImages() : const SizedBox(),
        AnimatedHorizontalList<String>(
          initialItems: images,
          scrollController: _scrollController,
          itemBuilder: (context, image, index, animation) {
            return Padding(
              key: ValueKey(image),
              padding: const EdgeInsets.all(8),
              child: ImageCard(imageUrl: image),
            );
          },
          removedItemBuilder: (
            String image,
            BuildContext context,
            Animation<double> animation,
          ) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ImageCard(imageUrl: image),
            );
          },
          onListHelperReady: (helper) => _imageListHelper = helper,
          listHeight: images.isEmpty ? 0 : 190,
          firstItemPadding: 20,
          lastItemPadding: 190,
        ),
      ],
    );
  }

  Widget _buildEmptyListImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Nenhuma imagem cadastrada',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.shadow,
          ),
        ),
      ],
    );
  }
}
