import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/show_all_services_controller.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/animated_list/custom_animated_list.dart';
import 'package:prestador_de_servico/app/shared/notifications/custom_notifications.dart';
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
  late ServicesByCategory servicesByCategory;
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    value: 1.0,
  );
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();
  late CustomAnimatedList<Service> _listServicesCategoryCard;
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

    _listServicesCategoryCard = CustomAnimatedList<Service>(
      listKey: _animatedListKey,
      removedItemBuilder: _buildRemovedItem,
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
                  hasService
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            widget.onDelete(serviceCategory: servicesByCategory.serviceCategory, index: widget.index);
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
                      initialItemCount: _listServicesCategoryCard.length + 2,
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
                      _onAddService(serviceCategory: servicesByCategory.serviceCategory);
                    },
                  )),
                  CustomLink(
                    label: 'Mostrar tudo',
                    onTap: _onShowAll,
                  ),
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

  void _onShowAll() {
    final servicesByCategoryToShowAll = servicesByCategory.copyWith(services: List.from(servicesByCategory.services));
    context.read<ShowAllServicesController>().setServicesByCategory(servicesByCategory: servicesByCategoryToShowAll);
    Navigator.of(context).pushNamed('/showAllServices', arguments: _removeServiceOfScreen);
  }

  Future<void> _onEdit() async {
    context.read<ServiceCategoryEditController>().initUpdate(serviceCategory: servicesByCategory.serviceCategory);
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
      final hasService = _listServicesCategoryCard.length > 0;

      if (hasService) await _scrollToEnd();

      final serviceInsert = result as Service;
      servicesByCategory.services.add(serviceInsert);

      if (hasService) {
        _listServicesCategoryCard.insert(serviceInsert);
      } else {
        setState(() {});
      }
    }
  }

  Future<void> _onEditService({
    required ServiceCategory serviceCategory,
    required Service service,
  }) async {
    final index = servicesByCategory.services.indexWhere((s) => s.id == service.id);
    widget.removeFocusOfWidgets();
    context.read<ServiceEditController>().initUpdate(
          serviceCategory: serviceCategory,
          service: service,
        );
    final result = await Navigator.of(context).pushNamed('/serviceEdit');
    if (result != null) {
      final serviceEdited = result as Service;
      servicesByCategory.services[index] = serviceEdited;

      _listServicesCategoryCard.removeAt(index, 0);
      _listServicesCategoryCard.insertAt(index, serviceEdited);
    }
  }

  void _onRemoveService({required Service service}) {
    _customNotifications.showQuestionAlert(
      context: context,
      title: 'Excluir serviço',
      content: 'Tem certeza que deseja excluir serviço?',
      confirmCallback: () {
        context.read<ServiceController>().deleteService(service: service);
        _removeServiceOfDatabase(service: service);
        _removeServiceOfScreen(service: service);
      },
    );
  }

  void _removeServiceOfScreen({required Service service}) {
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

  void _removeServiceOfDatabase({required Service service}) {
    context.read<ServiceController>().deleteService(service: service);
  }

  Future<void> _changeCategory(ServiceCategory serviceCategory) async {
    await controller.animateTo(0, curve: Curves.easeIn);
    servicesByCategory = servicesByCategory.copyWith(serviceCategory: serviceCategory);
    await controller.animateTo(1, curve: Curves.easeIn);
  }

  Widget _buildRemovedItem(
    Service service,
    BuildContext context,
    Animation<double> animation,
  ) {
    return ServiceCard(onTap: () {}, onLongPress: () {}, service: service, animation: animation);
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
    if (index == _listServicesCategoryCard.length) {
      return const SizedBox(
        key: ValueKey('last space'),
        width: 190,
      );
    }
    return ServiceCard(
      key: ValueKey(_listServicesCategoryCard[index].id),
      onTap: () {
        _onEditService(
          serviceCategory: servicesByCategory.serviceCategory,
          service: _listServicesCategoryCard[index],
        );
      },
      onLongPress: () {
        _onRemoveService(service: _listServicesCategoryCard[index]);
      },
      service: _listServicesCategoryCard[index],
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
