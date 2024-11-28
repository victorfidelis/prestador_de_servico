import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';
import 'package:provider/provider.dart';

class ServiceCategoryCard extends StatefulWidget {
  ServicesByCategory servicesByCategory;
  final Function({required ServiceCategory serviceCategory, required int index}) onDelete;
  final Function({required ServiceCategory serviceCategory}) onAddService;
  final int index;
  final Animation<double> animation;

  ServiceCategoryCard({
    super.key,
    required this.servicesByCategory,
    required this.onDelete,
    required this.onAddService,
    required this.index,
    required this.animation,
  });

  @override
  State<ServiceCategoryCard> createState() => _ServiceCategoryCardState();
}

class _ServiceCategoryCardState extends State<ServiceCategoryCard> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  @override
  void initState() {
    _controller.animateTo(1, curve: Curves.easeIn);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    final hasService = widget.servicesByCategory.services.isNotEmpty;

    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizeTransition(
        sizeFactor: widget.animation,
        child: FadeTransition(
          opacity: widget.animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, _) {
                            return Opacity(
                              opacity: _controller.value,
                              child: Text(
                                widget.servicesByCategory.serviceCategory.name,
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                          }),
                    ),
                    IconButton(
                      onPressed: () {
                        widget.onDelete(
                            serviceCategory: widget.servicesByCategory.serviceCategory, index: widget.index);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _onEdit();
                        // widget.onEdit(servicesByCategory: widget.servicesByCategory, index: widget.index);
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
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.servicesByCategory.services.length,
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
                        widget.onAddService(serviceCategory: widget.servicesByCategory.serviceCategory);
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
        ServiceCard(onTap: () {}, service: widget.servicesByCategory.services[index]),
        index == widget.servicesByCategory.services.length - 1 ? const SizedBox(width: 16) : Container(),
      ],
    );
  }

  Future<void> _onEdit() async {
    context
        .read<ServiceCategoryEditController>()
        .initUpdate(serviceCategory: widget.servicesByCategory.serviceCategory);
    final result = await Navigator.of(context).pushNamed('/serviceCategoryEdit');
    if (result != null) {
      final serviceCategoryUpdate = result as ServiceCategory;
      await _changeCategory(serviceCategoryUpdate);
    }
  }

  Future<void> _changeCategory(ServiceCategory serviceCategory) async {
    await _controller.animateTo(0, curve: Curves.easeIn);
    widget.servicesByCategory = widget.servicesByCategory.copyWith(serviceCategory: serviceCategory);
    await _controller.animateTo(1, curve: Curves.easeIn);
  }
}
