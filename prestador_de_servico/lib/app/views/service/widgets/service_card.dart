import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/shared/utils/data_converter.dart';
import 'package:prestador_de_servico/app/shared/utils/network/network_helpers.dart';
import 'package:prestador_de_servico/app/shared/widgets/image_card.dart';

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
              ImageCard(
                imageUrl: widget.service.imageUrl,
                defaultFileImage: 'assets/images/sem_imagem.jpg',
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
                            DataConverter.formatHoursAndMinutes(
                                widget.service.hours, widget.service.minutes),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          DataConverter.formatPrice(widget.service.price),
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
}
