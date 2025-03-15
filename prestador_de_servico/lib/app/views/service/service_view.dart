import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/services/service/services_by_category_service.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_viewmodel.dart';
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
  final bool isSelectionView;
  const ServiceView({super.key, this.isSelectionView = false});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  late final ServiceViewModel serviceViewModel;

  late List<ServicesByCategory> servicesByCategories;
  late List<ServicesByCategory> servicesByCategoriesInScreen;
  final CustomNotifications notifications = CustomNotifications();
  final GlobalKey<SliverAnimatedListState> animatedListKey = GlobalKey<SliverAnimatedListState>();
  late SliverAnimatedListHelper<ServicesByCategory> listServicesByCategories;
  final scrollController = ScrollController();
  final focusNodeSearchText = FocusNode();

  @override
  void initState() {
    listServicesByCategories = SliverAnimatedListHelper<ServicesByCategory>(
      listKey: animatedListKey,
      removedItemBuilder: buildRemovedItem,
      initialItems: [],
    );

    serviceViewModel = ServiceViewModel(
      serviceCategoryService: context.read<ServiceCategoryService>(),
      serviceService: context.read<ServiceService>(),
      servicesByCategoryService: context.read<ServicesByCategoryService>(),
    );

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
      title = 'Selecione um serviço';
    }
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
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
                          SizedBox(
                              width: 60,
                              child: BackNavigation(onTap: () => Navigator.pop(context))),
                          Expanded(
                            child: CustomAppBarTitle(title: title),
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
                      onChanged: onFilter,
                      focusNode: focusNodeSearchText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListenableBuilder(
            listenable: serviceViewModel,
            builder: (context, _) {
              if (serviceViewModel.state is ServiceInitial) {
                return const SliverFillRemaining();
              }
    
              if (serviceViewModel.state is ServiceError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((serviceViewModel.state as ServiceError).message),
                  ),
                );
              }
    
              if (serviceViewModel.state is ServiceLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CustomLoading(),
                  ),
                );
              }
    
              final categories = (serviceViewModel.state as ServiceLoaded).servicesByCategories;
              servicesByCategories = List.from(categories);
    
              if (serviceViewModel.state is ServiceFiltered) {
                final categoriesFiltered =
                    (serviceViewModel.state as ServiceFiltered).servicesByCategoriesFiltered;
                servicesByCategoriesInScreen = List.from(categoriesFiltered);
              } else {
                servicesByCategoriesInScreen = List.from(servicesByCategories);
              }
    
              listServicesByCategories.removeAndInsertAll(servicesByCategoriesInScreen);
    
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                sliver: SliverAnimatedList(
                  key: animatedListKey,
                  initialItemCount: listServicesByCategories.length + 1,
                  itemBuilder: itemBuilder,
                ),
              );
            },
          ),
        ],
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
                onTap: onAddServiceCategory,
              ),
            ),
    );
  }

  Widget itemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    if (listServicesByCategories.length == 0) {
      return Container();
    }
    if (index == listServicesByCategories.length) {
      return const SizedBox(
        key: ValueKey('last item key'),
        height: 220,
      );
    }
    if (index > listServicesByCategories.length) {
      return Container();
    }
    return ServiceCategoryCard(
      key: ValueKey(listServicesByCategories[index].serviceCategory.id),
      servicesByCategory: listServicesByCategories[index],
      onRemoveCategory: onRemoveServiceCategory,
      onRemoveService: onRemoveService,
      editServiceCategory: editServiceOfScreen,
      index: index,
      animation: animation,
      removeFocusOfWidgets: removeFocusOfWidgets,
      isSelectionView: widget.isSelectionView,
      onSelectedService: onSelectedService,
    );
  }

  Widget buildRemovedItem(
    ServicesByCategory servicesByCategory,
    BuildContext context,
    Animation<double> animation,
  ) {
    return ServiceCategoryCard(
      key: ValueKey(servicesByCategory.serviceCategory.id),
      servicesByCategory: servicesByCategory,
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

  Future<void> onAddServiceCategory() async {
    final result = await Navigator.of(context).pushNamed('/serviceCategoryEdit');
    if (result != null) {
      addServiceCategoryInScreen(serviceCategory: result as ServiceCategory);
    }
  }

  void addServiceCategoryInScreen({
    required ServiceCategory serviceCategory,
  }) async {
    final serviceByCategory = ServicesByCategory(serviceCategory: serviceCategory, services: []);
    await _scrollToEnd();
    servicesByCategories.add(serviceByCategory);
    servicesByCategoriesInScreen.add(serviceByCategory);
    listServicesByCategories.insert(serviceByCategory);
  }

  void editServiceOfScreen({required ServiceCategory serviceCategory}) {
    final indexOfCompleteList =
        servicesByCategories.indexWhere((s) => s.serviceCategory.id == serviceCategory.id);
    servicesByCategories[indexOfCompleteList].serviceCategory = serviceCategory;

    final indexOfListInScreen =
        servicesByCategoriesInScreen.indexWhere((s) => s.serviceCategory.id == serviceCategory.id);
    servicesByCategoriesInScreen[indexOfListInScreen].serviceCategory = serviceCategory;
  }

  void onRemoveServiceCategory({
    required ServiceCategory serviceCategory,
    required int index,
  }) {
    notifications.showQuestionAlert(
      context: context,
      title: 'Excluir categoria de serviço',
      content: 'Tem certeza que deseja excluir a categoria de serviço?',
      confirmCallback: () {
        removeServiceCategoryOfDatabase(serviceCategory: serviceCategory);
        removeServiceCategoryOfScreen(serviceCategory: serviceCategory);
      },
    );
  }

  void onRemoveService({required Service service}) {
    serviceViewModel.deleteService(service: service);
  }

  void removeServiceCategoryOfScreen({required ServiceCategory serviceCategory}) {
    servicesByCategories.removeWhere((s) => s.serviceCategory.id == serviceCategory.id);

    final index =
        servicesByCategoriesInScreen.indexWhere((s) => s.serviceCategory.id == serviceCategory.id);
    removeFocusOfWidgets();
    servicesByCategoriesInScreen.removeAt(index);
    listServicesByCategories.removeAt(index);
  }

  void removeServiceCategoryOfDatabase({required ServiceCategory serviceCategory}) {
    serviceViewModel.deleteCategory(serviceCategory: serviceCategory);
  }

  void onFilter(String textValue) {
    serviceViewModel.refreshValuesOfState(
      servicesByCategories: servicesByCategories,
      servicesByCategoriesFiltered: servicesByCategoriesInScreen,
    );
    serviceViewModel.filter(textFilter: textValue);
  }

  Future<void> _scrollToEnd() async {
    removeFocusOfWidgets();
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

  void onSelectedService(Service service) {
    Navigator.pop(context, service);
  }

  void removeFocusOfWidgets() {
    focusNodeSearchText.unfocus();
  }
}
