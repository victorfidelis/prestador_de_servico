import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';

class ServiceCategoryCard extends StatelessWidget {
  final ServicesByCategory servicesByCategory;
  final Function({required ServicesByCategory servicesByCategory, required int index}) onEdit;
  final Function({required ServiceCategory serviceCategory, required int index}) onDelete;
  final Function({required ServiceCategory serviceCategory}) onAddService;
  final int index;
  final Animation<double> animation;

  const ServiceCategoryCard({
    super.key,
    required this.servicesByCategory,
    required this.onEdit,
    required this.onDelete,
    required this.onAddService,
    required this.index,
    required this.animation,
  });

  @override
  build(BuildContext context) {
    final hasService = servicesByCategory.services.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(
        // horizontal: 12,
        vertical: 12,
      ),
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        servicesByCategory.serviceCategory.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        onDelete(serviceCategory: servicesByCategory.serviceCategory, index: index);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        onEdit(servicesByCategory: servicesByCategory, index: index);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              hasService ? const SizedBox(height: 6) : Container(),
              hasService
                  ? SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: servicesByCategory.services.length,
                        itemBuilder: (context, index) {
                          return _serviceWidget(index);
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomLink(
                      label: 'Adicionar novo',
                      onTap: () {
                        onAddService(serviceCategory: servicesByCategory.serviceCategory);
                      },
                    )),
                    CustomLink(label: 'Mostrar tudo', onTap: () {})
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceWidget(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        index == 0 ? const SizedBox(width: 16) : Container(),
        ServiceCard(onTap: () {}, service: servicesByCategory.services[index]),
        index == servicesByCategory.services.length - 1 ? const SizedBox(width: 16) : Container(),
      ],
    );
  }
}
