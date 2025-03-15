import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/animated_list_helper.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';

class ServiceCategoryCard extends StatefulWidget {
  final ServicesByCategory servicesByCategory;
  final Function({required ServiceCategory serviceCategory, required int index}) onRemoveCategory;
  final Function({required Service service}) onRemoveService;
  final Function({required ServiceCategory serviceCategory}) editServiceCategory;
  final int index;
  final Animation<double> animation;
  final void Function() removeFocusOfWidgets;
  final bool isSelectionView;
  final Function(Service service) onSelectedService;

  const ServiceCategoryCard({
    super.key,
    required this.servicesByCategory,
    required this.onRemoveCategory,
    required this.onRemoveService,
    required this.editServiceCategory,
    required this.index,
    required this.animation,
    required this.removeFocusOfWidgets,
    required this.isSelectionView,
    required this.onSelectedService,
  });

  @override
  State<ServiceCategoryCard> createState() => _ServiceCategoryCardState();
}

class _ServiceCategoryCardState extends State<ServiceCategoryCard> with TickerProviderStateMixin {
  late ServicesByCategory servicesByCategory;
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    value: 1.0,
  );
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();
  late AnimatedListHelper<Service> _listServicesCategoryCard;
  final _scrollController = ScrollController();
  final _customNotifications = CustomNotifications();

  @override
  void initState() {
    servicesByCategory = widget.servicesByCategory;
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
    final hasService = servicesByCategory.services.isNotEmpty;

    _listServicesCategoryCard = AnimatedListHelper<Service>(
      listKey: _animatedListKey,
      removedItemBuilder: buildRemovedItem,
      initialItems: servicesByCategory.services,
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
                              servicesByCategory.serviceCategory.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }),
                  ),
                  hasService || widget.isSelectionView
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () {
                            widget.onRemoveCategory(
                                serviceCategory: servicesByCategory.serviceCategory,
                                index: widget.index);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                  widget.isSelectionView
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () {
                            onEdit();
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
                      initialItemCount: _listServicesCategoryCard.length + 2,
                      itemBuilder: itemBuilder,
                    ),
                  )
                : Container(),
            const SizedBox(height: 6),
            widget.isSelectionView
                ? const SizedBox()
                : Padding(
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
                        CustomLink(
                          label: 'Mostrar tudo',
                          onTap: onShowAll,
                        ),
                      ],
                    ),
                  ),
            widget.isSelectionView ? const SizedBox() : const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: Theme.of(context).colorScheme.shadow, height: 2),
            ),
          ],
        ),
      ),
    );
  }

  void onShowAll() {
    final servicesByCategoryToShowAll =
        servicesByCategory.copyWith(services: List.from(servicesByCategory.services));

    Navigator.of(context).pushNamed(
      '/showAllServices',
      arguments: {
        'servicesByCategory': servicesByCategoryToShowAll,
        'removeServiceOfOtherScreen': removeServiceOfScreen,
        'addServiceOfOtherScreen': addServiceOfScreenWithoutScrool,
        'editServiceOfOtherScreen': editServiceOfScreen
      },
    );
  }

  Future<void> onEdit() async {
    final result = await Navigator.of(context).pushNamed(
      '/serviceCategoryEdit',
      arguments: {'serviceCategory': servicesByCategory.serviceCategory},
    );
    if (result != null) {
      final serviceCategoryUpdate = result as ServiceCategory;
      widget.editServiceCategory(serviceCategory: serviceCategoryUpdate);
      await _changeCategory(serviceCategoryUpdate);
    }
  }

  Future<void> onAddService({required ServiceCategory serviceCategory}) async {
    widget.removeFocusOfWidgets();
    final result = await Navigator.of(context).pushNamed(
      '/serviceEdit',
      arguments: {'serviceCategory': serviceCategory},
    );
    if (result != null) {
      addServiceOfScreen(service: result as Service);
    }
  }

  Future<void> addServiceOfScreen({
    required Service service,
  }) async {
    final hasService = _listServicesCategoryCard.length > 0;

    if (hasService) await scrollToEnd();

    servicesByCategory.services.add(service);

    if (hasService) {
      _listServicesCategoryCard.insert(service);
    } else {
      setState(() {});
    }
  }

  void addServiceOfScreenWithoutScrool({
    required Service service,
  }) async {
    final hasService = _listServicesCategoryCard.length > 0;

    servicesByCategory.services.add(service);

    if (hasService) {
      _listServicesCategoryCard.insert(service);
    } else {
      setState(() {});
    }
  }

  Future<void> onEditService({
    required ServiceCategory serviceCategory,
    required Service service,
  }) async {
    widget.removeFocusOfWidgets();

    final result = await Navigator.of(context).pushNamed(
      '/serviceEdit',
      arguments: {
        'serviceCategory': serviceCategory,
        'service': service,
      },
    );

    if (result != null) {
      editServiceOfScreen(service: result as Service);
    }
  }

  void editServiceOfScreen({required Service service}) {
    final index = servicesByCategory.services.indexWhere((s) => s.id == service.id);
    servicesByCategory.services[index] = service;

    _listServicesCategoryCard.removeAt(index, 0);
    _listServicesCategoryCard.insertAt(index, service);
  }

  void onRemoveService({required Service service}) {
    _customNotifications.showQuestionAlert(
      context: context,
      title: 'Excluir serviço',
      content: 'Tem certeza que deseja excluir serviço?',
      confirmCallback: () {
        widget.onRemoveService(service: service);
        removeServiceOfScreen(service: service);
      },
    );
  }

  void removeServiceOfScreen({required Service service}) {
    final index = servicesByCategory.services.indexWhere((s) => s.id == service.id);

    if (index < 0) {
      return;
    }

    widget.removeFocusOfWidgets();
    servicesByCategory.services.removeAt(index);
    _listServicesCategoryCard.removeAt(index);
    if (_listServicesCategoryCard.length == 0) {
      setState(() {});
    }
  }

  Future<void> _changeCategory(ServiceCategory serviceCategory) async {
    await controller.animateTo(0, curve: Curves.easeIn);
    servicesByCategory = servicesByCategory.copyWith(serviceCategory: serviceCategory);
    await controller.animateTo(1, curve: Curves.easeIn);
  }

  Widget buildRemovedItem(
    Service service,
    BuildContext context,
    Animation<double> animation,
  ) {
    return ServiceCard(onTap: () {}, onLongPress: () {}, service: service, animation: animation);
  }

  Widget itemBuilder(
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
    if (index == _listServicesCategoryCard.length) {
      return const SizedBox(
        key: ValueKey('last space'),
        width: 190,
      );
    }
    return ServiceCard(
      key: ValueKey(_listServicesCategoryCard[index].id),
      onTap: () {
        if (widget.isSelectionView) {
          widget.onSelectedService(_listServicesCategoryCard[index]);
        } else {
          onEditService(
            serviceCategory: servicesByCategory.serviceCategory,
            service: _listServicesCategoryCard[index],
          );
        }
      },
      onLongPress: () {
        onRemoveService(service: _listServicesCategoryCard[index]);
      },
      service: _listServicesCategoryCard[index],
      animation: animation,
    );
  }

  Future<void> scrollToEnd() async {
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
