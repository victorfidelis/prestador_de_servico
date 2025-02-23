import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_category_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/search_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/service/states/service_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_category_card.dart';
import 'package:provider/provider.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/sliver_animated_list_helper.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({super.key});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  late List<ServicesByCategory> servicesByCategories;
  late List<ServicesByCategory> servicesByCategoriesInScreen;
  final CustomNotifications _notifications = CustomNotifications();
  final GlobalKey<SliverAnimatedListState> _animatedListKey = GlobalKey<SliverAnimatedListState>();
  late SliverAnimatedListHelper<ServicesByCategory> _listServicesByCategories;
  final _scrollController = ScrollController();
  final focusNodeSearchText = FocusNode();

  @override
  void initState() {
    _listServicesByCategories = SliverAnimatedListHelper<ServicesByCategory>(
      listKey: _animatedListKey,
      removedItemBuilder: _buildRemovedItem,
      initialItems: [],
    );
    context.read<ServiceViewModel>().init();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<ServiceViewModel>().load());
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
                      hintText: 'Pesquise por uma categoria',
                      onChanged: _onFilter,
                      focusNode: focusNodeSearchText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<ServiceViewModel>(
            builder: (context, serviceCategoryViewModel, _) {
              if (serviceCategoryViewModel.state is ServiceInitial) {
                return const SliverFillRemaining();
              }

              if (serviceCategoryViewModel.state is ServiceError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((serviceCategoryViewModel.state as ServiceError).message),
                  ),
                );
              }

              if (serviceCategoryViewModel.state is ServiceLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CustomLoading(),
                  ),
                );
              }

              final categories = (serviceCategoryViewModel.state as ServiceLoaded).servicesByCategories;
              servicesByCategories = List.from(categories);

              if (serviceCategoryViewModel.state is ServiceFiltered) {
                final categoriesFiltered =
                    (serviceCategoryViewModel.state as ServiceFiltered).servicesByCategoriesFiltered;
                servicesByCategoriesInScreen = List.from(categoriesFiltered);
              } else {
                servicesByCategoriesInScreen = List.from(servicesByCategories);
              }

              _listServicesByCategories.removeAndInsertAll(servicesByCategoriesInScreen);

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
    if (_listServicesByCategories.length == 0) {
      return Container();
    }
    if (index == _listServicesByCategories.length) {
      return const SizedBox(
        key: ValueKey('last item key'),
        height: 220,
      );
    }
    if (index > _listServicesByCategories.length) {
      return Container();
    }
    return ServiceCategoryCard(
      key: ValueKey(_listServicesByCategories[index].serviceCategory.id),
      servicesByCategory: _listServicesByCategories[index],
      onDelete: _onRemoveServiceCategory,
      editServiceCategory: _editServiceOfScreen,
      index: index,
      animation: animation,
      removeFocusOfWidgets: removeFocusOfWidgets,
    );
  }

  Widget _buildRemovedItem(
    ServicesByCategory servicesByCategory,
    BuildContext context,
    Animation<double> animation,
  ) {
    return ServiceCategoryCard(
      key: ValueKey(servicesByCategory.serviceCategory.id),
      servicesByCategory: servicesByCategory,
      onDelete: ({required ServiceCategory serviceCategory, required int index}) {},
      editServiceCategory: ({required ServiceCategory serviceCategory}) {},
      index: 0,
      animation: animation,
      removeFocusOfWidgets: () {},
    );
  }

  Future<void> _onAddServiceCategory() async {
    context.read<ServiceCategoryEditViewModel>().initInsert();
    final result = await Navigator.of(context).pushNamed('/serviceCategoryEdit');
    if (result != null) {
      _addServiceCategoryInScreen(serviceCategory: result as ServiceCategory);
    }
  }

  void _addServiceCategoryInScreen({
    required ServiceCategory serviceCategory,
  }) async {
    final serviceByCategory = ServicesByCategory(serviceCategory: serviceCategory, services: []);
    await _scrollToEnd();
    servicesByCategories.add(serviceByCategory);
    servicesByCategoriesInScreen.add(serviceByCategory);
    _listServicesByCategories.insert(serviceByCategory);
  }
  

  void _editServiceOfScreen({required ServiceCategory serviceCategory}) {
    final indexOfCompleteList = servicesByCategories.indexWhere((s) => s.serviceCategory.id == serviceCategory.id);
    servicesByCategories[indexOfCompleteList].serviceCategory = serviceCategory;

    final indexOfListInScreen = servicesByCategoriesInScreen.indexWhere((s) => s.serviceCategory.id == serviceCategory.id);
    servicesByCategoriesInScreen[indexOfListInScreen].serviceCategory = serviceCategory;
  }

  void _onRemoveServiceCategory({
    required ServiceCategory serviceCategory,
    required int index,
  }) {
    _notifications.showQuestionAlert(
      context: context,
      title: 'Excluir categoria de serviço',
      content: 'Tem certeza que deseja excluir a categoria de serviço?',
      confirmCallback: () {
        _removeServiceCategoryOfDatabase(serviceCategory: serviceCategory);
        _removeServiceCategoryOfScreen(serviceCategory: serviceCategory);
      },
    );
  }

  void _removeServiceCategoryOfScreen({required ServiceCategory serviceCategory}) {
    servicesByCategories.removeWhere((s) => s.serviceCategory.id == serviceCategory.id);

    final index = servicesByCategoriesInScreen.indexWhere((s) => s.serviceCategory.id == serviceCategory.id);
    removeFocusOfWidgets();
    servicesByCategoriesInScreen.removeAt(index);
    _listServicesByCategories.removeAt(index);
  }

  void _removeServiceCategoryOfDatabase({required ServiceCategory serviceCategory}) {
    context.read<ServiceViewModel>().deleteCategory(serviceCategory: serviceCategory);
  }

  void _onFilter(String textValue) {
    context.read<ServiceViewModel>().refreshValuesOfState(
          servicesByCategories: servicesByCategories,
          servicesByCategoriesFiltered: servicesByCategoriesInScreen,
        );
    context.read<ServiceViewModel>().filter(textFilter: textValue);
  }

  Future<void> _scrollToEnd() async {
    removeFocusOfWidgets();
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

  void removeFocusOfWidgets() {
    focusNodeSearchText.unfocus();
  }
}
