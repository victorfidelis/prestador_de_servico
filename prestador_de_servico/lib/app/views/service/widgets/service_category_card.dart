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

  const ServiceCategoryCard({
    super.key,
    required this.servicesByCategory,
    required this.onDelete,
    required this.index,
    required this.animation,
  });

  @override
  State<ServiceCategoryCard> createState() => _ServiceCategoryCardState();
}

class _ServiceCategoryCardState extends State<ServiceCategoryCard> with TickerProviderStateMixin {
  late ServicesByCategory _serviceByCategory;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey<AnimatedListState>();
  late CustomAnimatedList<Service> _listServices;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _serviceByCategory = widget.servicesByCategory;
    _controller.animateTo(1, curve: Curves.easeIn);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    final hasService = _serviceByCategory.services.isNotEmpty;

    _listServices = CustomAnimatedList<Service>(
      listKey: _animatedListKey,
      removedItemBuilder: _buildRemovedItem,
      initialItems: _serviceByCategory.services,
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
                        animation: _controller,
                        builder: (context, _) {
                          return Opacity(
                            opacity: _controller.value,
                            child: Text(
                              _serviceByCategory.serviceCategory.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onDelete(serviceCategory: _serviceByCategory.serviceCategory, index: widget.index);
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
                      initialItemCount: _serviceByCategory.services.length + 1,
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
                      _onAddService(serviceCategory: _serviceByCategory.serviceCategory);
                    },
                  )),
                  CustomLink(label: 'Mostrar tudo', onTap: () {})
                ],
              ),
            ),
            SizedBox(height: 10),
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
    context.read<ServiceCategoryEditController>().initUpdate(serviceCategory: _serviceByCategory.serviceCategory);
    final result = await Navigator.of(context).pushNamed('/serviceCategoryEdit');
    if (result != null) {
      final serviceCategoryUpdate = result as ServiceCategory;
      await _changeCategory(serviceCategoryUpdate);
    }
  }

  Future<void> _onAddService({required ServiceCategory serviceCategory}) async {
    context.read<ServiceEditController>().initInsert(serviceCategory: serviceCategory);
    final result = await Navigator.of(context).pushNamed('/serviceEdit');
    if (result != null) {
      await _scrollToEnd();
      final serviceInsert = result as Service;
      _serviceByCategory.services.add(serviceInsert);
      _listServices.insert(serviceInsert);
    }
  }

  Future<void> _changeCategory(ServiceCategory serviceCategory) async {
    await _controller.animateTo(0, curve: Curves.easeIn);
    _serviceByCategory = _serviceByCategory.copyWith(serviceCategory: serviceCategory);
    await _controller.animateTo(1, curve: Curves.easeIn);
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
    if (index == _listServices.length) {
      return const SizedBox(
        width: 180,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        index == 0 ? const SizedBox(width: 16) : Container(),
        ServiceCard(onTap: () {}, service: _listServices[index], animation: animation),
        index == _listServices.length - 1 ? const SizedBox(width: 16) : Container(),
      ],
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
