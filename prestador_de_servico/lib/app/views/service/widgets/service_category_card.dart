import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';

class ServiceCategoryCard extends StatelessWidget {
  final ServiceCategoryModel serviceCategory;
  const ServiceCategoryCard({
    super.key,
    required this.serviceCategory,
  });

  @override
  build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  serviceCategory.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                  child: CustomLink(
                label: 'Adicionar novo',
                onTap: () {},
              )),
              CustomLink(label: 'Mostrar tudo', onTap: () {})
            ],
          )
        ],
      ),
    );
  } 
}
