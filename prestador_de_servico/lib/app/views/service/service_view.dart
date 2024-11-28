import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_edit_controller.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/search_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/states/service/service_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_category_card.dart';
import 'package:provider/provider.dart';
import 'package:prestador_de_servico/app/shared/helpers/custom_animated_list.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({super.key});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  final CustomNotifications _notifications = CustomNotifications();
  final GlobalKey<SliverAnimatedListState> _animatedListKey = GlobalKey<SliverAnimatedListState>();
  late CustomAnimatedList<ServicesByCategory> _listServicesByCategories;
  final _scrollController = ScrollController();

  @override
  void initState() {
    context.read<ServiceController>().init();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<ServiceController>().load());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 144,
              minHeight: 144,
              child: Stack(
                children: [
                  CustomHeaderContainer(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 60, child: BackNavigation(onTap: () => Navigator.pop(context))),
                          const Expanded(
                            child: CustomAppBarTitle(title: 'Serviços'),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 94),
                    child: SearchTextField(
                      hintText: 'Pesquise por um serviço ou categoria',
                      onChanged: (String value) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<ServiceController>(
            builder: (context, serviceCategoryController, _) {
              if (serviceCategoryController.state is ServiceInitial) {
                return const SliverFillRemaining();
              }

              if (serviceCategoryController.state is ServiceError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((serviceCategoryController.state as ServiceError).message),
                  ),
                );
              }

              if (serviceCategoryController.state is ServiceLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CustomLoading(),
                  ),
                );
              }

              _listServicesByCategories = CustomAnimatedList<ServicesByCategory>(
                  listKey: _animatedListKey,
                  removedItemBuilder: _buildRemovedItem,
                  initialItems: (serviceCategoryController.state as ServiceLoaded).servicesByCategories);

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                sliver: SliverAnimatedList(
                  key: _animatedListKey,
                  initialItemCount: _listServicesByCategories.length + 1,
                  itemBuilder: _itemBuilder,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 44,
          vertical: 10,
        ),
        child: CustomButton(
          label: 'Nova categoria',
          onTap: _onAddServiceCategory,
        ),
      ),
    );
  }

  Widget _itemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    if (index == _listServicesByCategories.length) {
      return const SizedBox(
        height: 220,
      );
    }
    return Column(
      children: [
        ServiceCategoryCard(
          servicesByCategory: _listServicesByCategories[index],
          onDelete: _onDeleteServiceCategory,
          onAddService: _onAddService,
          index: index,
          animation: animation,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Divider(color: Theme.of(context).colorScheme.shadow, height: 2),
        ),
      ],
    );
  }

  Widget _buildRemovedItem(
    ServicesByCategory servicesByCategory,
    BuildContext context,
    Animation<double> animation,
  ) {
    return Column(
      children: [
        ServiceCategoryCard(
          servicesByCategory: servicesByCategory,
          onDelete: ({required ServiceCategory serviceCategory, required int index}) {},
          onAddService: ({required ServiceCategory serviceCategory}) {},
          index: 0,
          animation: animation,
        ),
        Divider(color: Theme.of(context).colorScheme.shadow),
      ],
    );
  }

  Future<void> _onAddServiceCategory() async {
    context.read<ServiceCategoryEditController>().initInsert();
    final result = await Navigator.of(context).pushNamed('/serviceCategoryEdit');
    if (result != null) {
      await _scrollToEnd();
      final serviceCategoryInsert = result as ServiceCategory;
      _onInsertServiceCategory(serviceCategory: serviceCategoryInsert);
    }
  }

  void _onInsertServiceCategory({
    required ServiceCategory serviceCategory,
  }) {
    final serviceByCategory = ServicesByCategory(serviceCategory: serviceCategory, services: []);
    _listServicesByCategories.insert(serviceByCategory);
  }

  void _onDeleteServiceCategory({
    required ServiceCategory serviceCategory,
    required int index,
  }) {
    _notifications.showQuestionAlert(
      context: context,
      title: 'Excluir categoria de serviço',
      content: 'Tem certeza que deseja excluir a categoria de serviço?',
      confirmCallback: () {
        _listServicesByCategories.removeAt(index);
        context.read<ServiceController>().deleteCategory(serviceCategory: serviceCategory);
      },
    );
  }
  
  Future<void> _onAddService({required ServiceCategory serviceCategory}) async {
    context.read<ServiceEditController>().initInsert(serviceCategory: serviceCategory);
    await Navigator.of(context).pushNamed('/serviceEdit');
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
