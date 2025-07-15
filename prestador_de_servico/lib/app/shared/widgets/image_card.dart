import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';

class ImageCard extends StatefulWidget {
  final String imageUrl;
  final String defaultFileImage;
  final Function()? onLongPress;
  const ImageCard({
    super.key,
    this.imageUrl = '',
    this.defaultFileImage = 'assets/images/sem_imagem.jpg',
    this.onLongPress,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  final ValueNotifier<Widget> image = ValueNotifier(
    Image.asset('assets/images/sem_imagem.jpg', fit: BoxFit.cover),
  );

  @override
  Widget build(BuildContext context) {
    _loadImage();

    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        height: 136,
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
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: ListenableBuilder(
            listenable: image,
            builder: (context, _) {
              return image.value;
            },
          ),
        ),
      ),
    );
  }

  void _loadImage() {
    image.value = CachedNetworkImage(
      imageUrl: widget.imageUrl,
      placeholder: (context, url) => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: CustomLoading(),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset('assets/images/imagem_indisponivel.jpg'),
      fit: BoxFit.cover,
    );
  }
}
