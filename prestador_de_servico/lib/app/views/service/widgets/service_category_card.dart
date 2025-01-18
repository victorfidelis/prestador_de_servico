import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_edit_controller.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/helpers/custom_animated_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';
import 'package:provider/provider.dart';

class ServiceCategoryCard extends StatefulWidget {
  final ServicesByCategory servicesByCategory;
  final Function({required ServiceCategory serviceCategory, required int index}) onDelete;
  final int index;
  final Animation<double> animation;
  final void Function() removeFocusOfWidgets;

  const ServiceCategoryCard({
    super.key,
    required this.servicesByCategory,
    required this.onDelete,
    required this.index,
    required this.animation,
    required this.removeFocusOfWidgets,
  });

  @override
  State<ServiceCategoryCard> createState() => _ServiceCategoryCardState();
}

class _ServiceCategoryCardState extends State<ServiceCategoryCard> with TickerProviderStateMixin {
  late ServicesByCategory serviceByCategory;
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    value: 1.0,
  );
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();
  late CustomAnimatedList<Service> _listServices;
  final _scrollController = ScrollController();

  @override
  void initState() {
    serviceByCategory = widget.servicesByCategory;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    final hasService = serviceByCategory.services.isNotEmpty;

    _listServices = CustomAnimatedList<Service>(
      listKey: _animatedListKey,
      removedItemBuilder: _buildRemovedItem,
      initialItems: serviceByCategory.services,
    );

    return SizeTransition(
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
                        animation: controller,
                        builder: (context, _) {
                          return Opacity(
                            opacity: controller.value,
                            child: Text(
                              serviceByCategory.serviceCategory.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }),
                  ),
                  hasService
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            widget.onDelete(serviceCategory: serviceByCategory.serviceCategory, index: widget.index);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                  IconButton(
                    onPressed: () {
                      _onEdit();
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            hasService
                ? const SizedBox(height: 6)
                : Container(
                    padding: const EdgeInsets.only(left: 38, bottom: 8),
                    child: const Text(
                      'Sem serviços cadastrados',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
            hasService
                ? SizedBox(
                    height: 190,
                    child: AnimatedList(
                      key: _animatedListKey,
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      initialItemCount: _listServices.length + 2,
                      itemBuilder: _itemBuilder,
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
                      _onAddService(serviceCategory: serviceByCategory.serviceCategory);
                    },
                  )),
                  CustomLink(label: 'Mostrar tudo', onTap: () {})
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: Theme.of(context).colorScheme.shadow, height: 2),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onEdit() async {
    context.read<ServiceCategoryEditController>().initUpdate(serviceCategory: serviceByCategory.serviceCategory);
    final result = await Navigator.of(context).pushNamed('/serviceCategoryEdit');
    if (result != null) {
      final serviceCategoryUpdate = result as ServiceCategory;
      await _changeCategory(serviceCategoryUpdate);
    }
  }

  Future<void> _onAddService({required ServiceCategory serviceCategory}) async {
    widget.removeFocusOfWidgets();
    context.read<ServiceEditController>().initInsert(serviceCategory: serviceCategory);
    final result = await Navigator.of(context).pushNamed('/serviceEdit');
    if (result != null) {
      final hasService = _listServices.length > 0;

      if (hasService) await _scrollToEnd();

      final serviceInsert = result as Service;
      serviceByCategory.services.add(serviceInsert);

      if (hasService) {
        _listServices.insert(serviceInsert);
      } else {
        setState(() {});
      }
    }
  }

  Future<void> _onEditService({
    required ServiceCategory serviceCategory,
    required Service service,
    required int index,
  }) async {
    widget.removeFocusOfWidgets();
    context.read<ServiceEditController>().initUpdate(
          serviceCategory: serviceCategory,
          service: service,
        );
    final result = await Navigator.of(context).pushNamed('/serviceEdit');
    if (result != null) {
      final serviceEdited = result as Service;
      serviceByCategory.services[index] = serviceEdited;

      _listServices.removeAt(index, 0);
      _listServices.insertAt(index, serviceEdited);
    }
  }


  Future<void> _changeCategory(ServiceCategory serviceCategory) async {
    await controller.animateTo(0, curve: Curves.easeIn);
    serviceByCategory = serviceByCategory.copyWith(serviceCategory: serviceCategory);
    await controller.animateTo(1, curve: Curves.easeIn);
  }

  Widget _buildRemovedItem(
    Service service,
    BuildContext context,
    Animation<double> animation,
  ) {
    return ServiceCard(onTap: () {}, service: service, animation: animation);
  }

  Widget _itemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    index--;
    if (index == -1) {
      return const SizedBox(
        key: ValueKey('first space'),
        width: 16,
      );
    }
    if (index == _listServices.length) {
      return const SizedBox(
        key: ValueKey('last space'),
        width: 190,
      );
    }
    return ServiceCard(
      key: ValueKey(_listServices[index].id),
      onTap: () {
        _onEditService(
          serviceCategory: serviceByCategory.serviceCategory,
          service: _listServices[index],
          index: index,
        );
      },
      service: _listServices[index],
      animation: animation,
    );
  }

  Future<void> _scrollToEnd() async {
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}
