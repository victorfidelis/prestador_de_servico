import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/animated_list_helper.dart';
import 'package:prestador_de_servico/app/shared/widgets/animated_horizontal_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_link.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';

class ServiceCategoryCard extends StatefulWidget {
  final ServiceCategory serviceCategory;
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
    required this.serviceCategory,
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
  late ServiceCategory serviceCategory;
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    value: 1.0,
  );

  AnimatedListHelper<Service>? _serviceListHelper;

  final _scrollController = ScrollController();
  final _customNotifications = CustomNotifications();

  @override
  void initState() {
    serviceCategory = widget.serviceCategory;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasService = serviceCategory.services.isNotEmpty;

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
                            serviceCategory.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                    ),
                  ),
                  hasService || widget.isSelectionView
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () {
                            widget.onRemoveCategory(serviceCategory: serviceCategory, index: widget.index);
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
            AnimatedHorizontalList<Service>(
              key: ValueKey(serviceCategory.id),
              initialItems: serviceCategory.services,
              scrollController: _scrollController,
              itemBuilder: (context, service, index, animation) {
                return ServiceCard(
                  key: ValueKey(service.id),
                  onTap: () {
                    if (widget.isSelectionView) {
                      widget.onSelectedService(service);
                    } else {
                      _onEditService(
                        serviceCategory: serviceCategory,
                        service: service,
                      );
                    }
                  },
                  onLongPress: () => _onRemoveService(service: service),
                  service: service,
                  animation: animation,
                );
              },
              removedItemBuilder: (
                Service service,
                BuildContext context,
                Animation<double> animation,
              ) {
                return ServiceCard(onTap: () {}, onLongPress: () {}, service: service, animation: animation);
              },
              onListHelperReady: (helper) => _serviceListHelper = helper,
              listHeight: hasService ? 190 : 0,
              firstItemPadding: 16,
              lastItemPadding: 190,
            ),
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
                            _onAddService(serviceCategory: serviceCategory);
                          },
                        )),
                        CustomLink(
                          label: 'Mostrar tudo',
                          onTap: _onShowAll,
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

  void _onShowAll() {
    final serviceCategoryToShowAll = serviceCategory.copyWith(services: List.from(serviceCategory.services));

    Navigator.of(context).pushNamed(
      '/showAllServices',
      arguments: {
        'serviceCategory': serviceCategoryToShowAll,
        'removeServiceOfOtherScreen': _removeService,
        'addServiceOfOtherScreen': _addServiceOfScreenWithoutScrool,
        'editServiceOfOtherScreen': _editServiceOfScreen
      },
    );
  }

  Future<void> _onEdit() async {
    final result = await Navigator.of(context).pushNamed(
      '/serviceCategoryEdit',
      arguments: {'serviceCategory': serviceCategory},
    );
    if (result != null) {
      final serviceCategoryUpdate = result as ServiceCategory;
      widget.editServiceCategory(serviceCategory: serviceCategoryUpdate);
      await _changeCategory(serviceCategoryUpdate);
    }
  }

  Future<void> _onAddService({required ServiceCategory serviceCategory}) async {
    widget.removeFocusOfWidgets();
    final result = await Navigator.of(context).pushNamed(
      '/serviceEdit',
      arguments: {'serviceCategory': serviceCategory},
    );
    if (result != null) {
      _addServiceOfScreen(service: result as Service);
    }
  }

  Future<void> _addServiceOfScreen({required Service service}) async {
    final hasService = _serviceListHelper!.length > 0;

    if (hasService) await _scrollToEnd();
    serviceCategory.services.add(service);
    _serviceListHelper!.insert(service);
    if (!hasService) {
      setState(() {});
    }
  }

  void _addServiceOfScreenWithoutScrool({required Service service}) async {
    final hasService = _serviceListHelper!.length > 0;
    serviceCategory.services.add(service);
    if (hasService) {
      _serviceListHelper!.insert(service);
    } else {
      setState(() {});
    }
  }

  Future<void> _onEditService({
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
      _editServiceOfScreen(service: result as Service);
    }
  }

  void _editServiceOfScreen({required Service service}) {
    final index = serviceCategory.services.indexWhere((s) => s.id == service.id);
    serviceCategory.services[index] = service;

    _serviceListHelper!.removeAt(index, 0);
    _serviceListHelper!.insertAt(index, service);
  }

  void _onRemoveService({required Service service}) {
    _customNotifications.showQuestionAlert(
      context: context,
      title: 'Excluir serviço',
      content: 'Tem certeza que deseja excluir serviço?',
      confirmCallback: () {
        widget.onRemoveService(service: service);
        _removeService(service: service);
      },
    );
  }

  void _removeService({required Service service}) {
    final index = serviceCategory.services.indexWhere((s) => s.id == service.id);

    if (index < 0) {
      return;
    }

    widget.removeFocusOfWidgets();
    serviceCategory.services.removeAt(index);
    _serviceListHelper!.removeAt(index);
    if (_serviceListHelper!.length == 0) {
      setState(() {});
    }
  }

  Future<void> _changeCategory(ServiceCategory serviceCategory) async {
    await controller.animateTo(0, curve: Curves.easeIn);
    this.serviceCategory = this.serviceCategory.copyWith(id: serviceCategory.id, name: serviceCategory.name);
    await controller.animateTo(1, curve: Curves.easeIn);
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
