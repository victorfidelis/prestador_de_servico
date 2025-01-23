import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/shared/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/network/network_helpers.dart';

class ServiceCard extends StatefulWidget {
  final Function() onTap;
  final Function() onLongPress;
  final Service service;
  final Animation<double> animation;

  const ServiceCard({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.service,
    required this.animation,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  final NetworkHelpers networkHelpers = NetworkHelpers();

  ValueNotifier<Widget> image = ValueNotifier(
    Image.asset('assets/images/sem_imagem.jpg', fit: BoxFit.cover),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.service.imageUrl.isNotEmpty) {
      image.value = Image.asset(
        'assets/images/tres_pontos_transparente.png',
        fit: BoxFit.cover,
      );
      getImageFromNetwotk();
    } else {
      image.value = Image.asset('assets/images/sem_imagem.jpg', fit: BoxFit.cover);
    }

    return SizeTransition(
      sizeFactor: widget.animation,
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Container(
          width: 180,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            Formatters.formatHoursAndMinutes(widget.service.hours, widget.service.minutes),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          Formatters.formatPrice(widget.service.price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff169A00),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getImageFromNetwotk() async {
    if (await networkHelpers.isImageLinkOnline(widget.service.imageUrl)) {
      image.value = FadeInImage.assetNetwork(
        placeholder: 'assets/images/tres_pontos_transparente.png',
        image: widget.service.imageUrl,
        fit: BoxFit.cover,
      );
    } else  {
      image.value = Image.asset('assets/images/imagem_indisponivel.jpg', fit: BoxFit.cover);
    }
  }
}
