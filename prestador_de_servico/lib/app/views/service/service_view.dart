import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_with_search.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_category_card.dart';
import 'package:provider/provider.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/sliver_animated_list_helper.dart';

class ServiceView extends StatefulWidget {
  final bool isSelectionView;
  const ServiceView({super.key, this.isSelectionView = false});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  late final ServiceViewModel serviceViewModel;

  final GlobalKey<SliverAnimatedListState> animatedListKey = GlobalKey<SliverAnimatedListState>();
  late SliverAnimatedListHelper<ServiceCategory> listServiceCategories;
  final scrollController = ScrollController();
  final focusNodeSearchText = FocusNode();

  @override
  void initState() {
    listServiceCategories = SliverAnimatedListHelper<ServiceCategory>(
      listKey: animatedListKey,
      removedItemBuilder: _removedItemBuilder,
      initialItems: [],
    );

    serviceViewModel = ServiceViewModel(
      serviceCategoryService: context.read<ServiceCategoryService>(),
      serviceService: context.read<ServiceService>(),
    );

    serviceViewModel.notificationMessage.addListener(() {
      if (serviceViewModel.notificationMessage.value != null) {
        CustomNotifications().showSnackBar(context: context, message: serviceViewModel.notificationMessage.value!);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => serviceViewModel.load());
    super.initState();
  }

  @override
  void dispose() {
    serviceViewModel.dispose();
    scrollController.dispose();
    focusNodeSearchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title;
    if (widget.isSelectionView) {
      title = 'Selecione um serviço';
    } else {
      title = 'Serviços';
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverFloatingHeader(
              child: CustomHeaderWithSearch(
                title: title,
                searchTitle: 'Pesquise por uma categoria',
                onSearch: _onSearch,
                focusNode: focusNodeSearchText,
              ),
            ),
            ListenableBuilder(
              listenable: serviceViewModel,
              builder: (context, _) {
                if (serviceViewModel.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(serviceViewModel.errorMessage!),
                    ),
                  );
                }

                if (serviceViewModel.serviceLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }

                if (serviceViewModel.serviceCategories.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }

                if (serviceViewModel.serviceFiltered) {
                  listServiceCategories.removeAndInsertAll(serviceViewModel.serviceCategoriesFiltered);
                } else {
                  listServiceCategories.removeAndInsertAll(serviceViewModel.serviceCategories);
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  sliver: SliverAnimatedList(
                    key: animatedListKey,
                    initialItemCount: listServiceCategories.length + 1,
                    itemBuilder: _itemBuilder,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.isSelectionView
          ? const SizedBox()
          : Padding(
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
    if (listServiceCategories.length == 0) {
      return const SizedBox();
    }
    if (index == listServiceCategories.length) {
      return const SizedBox(
        key: ValueKey('last item key'),
        height: 220,
      );
    }
    if (index > listServiceCategories.length) {
      return const SizedBox();
    }
    return ServiceCategoryCard(
      key: ValueKey(listServiceCategories[index].id),
      serviceCategory: listServiceCategories[index],
      onRemoveCategory: _onRemoveServiceCategory,
      onRemoveService: _onRemoveService,
      editServiceCategory: serviceViewModel.editServiceCategory,
      index: index,
      animation: animation,
      removeFocusOfWidgets: _removeFocusOfWidgets,
      isSelectionView: widget.isSelectionView,
      onSelectedService: _onSelectedService,
    );
  }

  Widget _removedItemBuilder(
    ServiceCategory serviceCategory,
    BuildContext context,
    Animation<double> animation,
  ) {
    return ServiceCategoryCard(
      key: ValueKey(serviceCategory.id),
      serviceCategory: serviceCategory,
      onRemoveCategory: ({required ServiceCategory serviceCategory, required int index}) {},
      onRemoveService: ({required Service service}) {},
      editServiceCategory: ({required ServiceCategory serviceCategory}) {},
      index: 0,
      animation: animation,
      removeFocusOfWidgets: () {},
      isSelectionView: false,
      onSelectedService: (_) {},
    );
  }

  Future<void> _onAddServiceCategory() async {
    final result = await Navigator.of(context).pushNamed('/serviceCategoryEdit');
    if (result != null) {
      _addServiceCategory(serviceCategory: result as ServiceCategory);
    }
  }

  Future<void> _addServiceCategory({required ServiceCategory serviceCategory}) async {
    await _scrollToEnd();
    serviceViewModel.addServiceCategory(serviceCategory: serviceCategory);
    listServiceCategories.insert(serviceCategory);
  }

  void _onRemoveServiceCategory({
    required ServiceCategory serviceCategory,
    required int index,
  }) {
    CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Excluir categoria de serviço',
      content: 'Tem certeza que deseja excluir a categoria de serviço?',
      confirmCallback: () {
        _removeServiceCategory(serviceCategory: serviceCategory, index: index);
      },
    );
  }

  void _removeServiceCategory({required ServiceCategory serviceCategory, required int index}) {
    serviceViewModel.deleteCategory(serviceCategory: serviceCategory);
    _removeFocusOfWidgets();
    listServiceCategories.removeAt(index);
  }

  void _onRemoveService({required Service service}) {
    serviceViewModel.deleteService(service: service);
  }

  void _onSearch(String textValue) {
    serviceViewModel.filter(textFilter: textValue);
  }

  Future<void> _scrollToEnd() async {
    _removeFocusOfWidgets();
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  void _onSelectedService(Service service) {
    Navigator.pop(context, service);
  }

  void _removeFocusOfWidgets() {
    focusNodeSearchText.unfocus();
  }
}
