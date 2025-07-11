import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_with_search.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/show_all_services_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/sliver_animated_grid_helper.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/service/states/show_all_services_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';
import 'package:provider/provider.dart';

class ShowAllServicesView extends StatefulWidget {
  final ServicesByCategory servicesByCategory;
  final Function({required Service service}) removeServiceOfOtherScreen;
  final Function({required Service service}) addServiceOfOtherScreen;
  final Function({required Service service}) editServiceOfOtherScreen;

  const ShowAllServicesView({
    super.key,
    required this.servicesByCategory,
    required this.removeServiceOfOtherScreen,
    required this.addServiceOfOtherScreen,
    required this.editServiceOfOtherScreen,
  });

  @override
  State<ShowAllServicesView> createState() => _ShowAllServicesViewState();
}

class _ShowAllServicesViewState extends State<ShowAllServicesView> {
  late final ShowAllServicesViewModel showAllServicesViewModel;
  late ServicesByCategory servicesByCategory;
  late ServicesByCategory servicesByCategoryInScreen;
  final GlobalKey<SliverAnimatedGridState> animatedGridKey = GlobalKey<SliverAnimatedGridState>();
  late SliverAnimatedGridHelper<Service> listServicesShowAll;
  final scrollController = ScrollController();
  final focusNodeSearchText = FocusNode();
  final customNotifications = CustomNotifications();

  @override
  void initState() {
    showAllServicesViewModel = ShowAllServicesViewModel(
      serviceService: context.read<ServiceService>(),
      servicesByCategory: widget.servicesByCategory,
    );

    listServicesShowAll = SliverAnimatedGridHelper<Service>(
      gridKey: animatedGridKey,
      removedItemBuilder: _buildRemovedItem,
      initialItems: [],
    );
    super.initState();
  }

  @override
  void dispose() {
    showAllServicesViewModel.dispose();
    scrollController.dispose();
    focusNodeSearchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverFloatingHeader(
              child: CustomHeaderWithSearch(
                title: 'Serviços',
                searchTitle: 'Pesquise por um serviço',
                onSearch: onFilter,
                focusNode: focusNodeSearchText,
              ),
            ),
            ListenableBuilder(
              listenable: showAllServicesViewModel,
              builder: (context, _) {
                if (showAllServicesViewModel.state is! ShowAllServicesLoaded) {
                  return const SliverToBoxAdapter();
                }
        
                final serviceCategory =
                    (showAllServicesViewModel.state as ShowAllServicesLoaded).servicesByCategory.serviceCategory;
        
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 18,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      serviceCategory.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
            ListenableBuilder(
              listenable: showAllServicesViewModel,
              builder: (context, _) {
                if (showAllServicesViewModel.state is ShowAllServicesInitial) {
                  return const SliverFillRemaining();
                }
        
                if (showAllServicesViewModel.state is ShowAllServicesError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text((showAllServicesViewModel.state as ShowAllServicesError).message),
                    ),
                  );
                }
        
                if (showAllServicesViewModel.state is ShowAllServicesLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }
        
                final loadedState = (showAllServicesViewModel.state as ShowAllServicesLoaded);
                final services = loadedState.servicesByCategory.services;
                servicesByCategory = loadedState.servicesByCategory.copyWith(services: List.from(services));
        
                if (showAllServicesViewModel.state is ShowAllServicesFiltered) {
                  final filteredState = (showAllServicesViewModel.state as ShowAllServicesFiltered);
                  final servicesFiltered = filteredState.servicesByCategoryFiltered.services;
                  servicesByCategoryInScreen =
                      filteredState.servicesByCategoryFiltered.copyWith(services: List.from(servicesFiltered));
                } else {
                  servicesByCategoryInScreen =
                      servicesByCategory.copyWith(services: List.from(servicesByCategory.services));
                }
        
                listServicesShowAll.removeAndInsertAll(servicesByCategoryInScreen.services);
        
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  sliver: SliverAnimatedGrid(
                    key: animatedGridKey,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 2),
                    initialItemCount: listServicesShowAll.length + 2,
                    itemBuilder: _itemBuilder,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 44,
          vertical: 10,
        ),
        child: CustomButton(
          label: 'Novo serviço',
          onTap: _onAddService,
        ),
      ),
    );
  }

  Future<void> _onAddService() async {
    _removeFocusOfWidgets();
    final result = await Navigator.of(context)
        .pushNamed('/serviceEdit', arguments: {'serviceCategory': servicesByCategory.serviceCategory});
    if (result != null) {
      final serviceAdd = result as Service;
      widget.addServiceOfOtherScreen(service: serviceAdd);
      _addServiceOfScreen(service: serviceAdd);
    }
  }

  Future<void> _addServiceOfScreen({required Service service}) async {
    final hasService = listServicesShowAll.length > 0;
    if (hasService) await _scrollToEnd();
    servicesByCategory.services.add(service);
    servicesByCategoryInScreen.services.add(service);
    listServicesShowAll.insert(service);
  }

  Future<void> _onEditService({required Service service}) async {
    _removeFocusOfWidgets();

    final result = await Navigator.of(context).pushNamed(
      '/serviceEdit',
      arguments: {
        'serviceCategory': servicesByCategory.serviceCategory,
        'service': service,
      },
    );

    if (result != null) {
      final serviceEdited = result as Service;
      widget.editServiceOfOtherScreen(service: serviceEdited);
      _editServiceOfScreen(service: serviceEdited);
    }
  }

  void _editServiceOfScreen({required Service service}) {
    final indexOfCompleteList = servicesByCategory.services.indexWhere((s) => s.id == service.id);
    servicesByCategory.services[indexOfCompleteList] = service;

    final indexOfListInScreen = servicesByCategoryInScreen.services.indexWhere((s) => s.id == service.id);
    servicesByCategoryInScreen.services[indexOfListInScreen] = service;

    listServicesShowAll.removeAt(indexOfListInScreen, 0);
    listServicesShowAll.insertAt(indexOfListInScreen, service);
  }

  void _onRemoveService({required Service service}) {
    customNotifications.showQuestionAlert(
      context: context,
      title: 'Excluir serviço',
      content: 'Tem certeza que deseja excluir serviço?',
      confirmCallback: () {
        removeServiceOfDatabase(service: service);
        widget.removeServiceOfOtherScreen(service: service);
        _removeServiceOfScreen(service: service);
      },
    );
  }

  void _removeServiceOfScreen({required Service service}) {
    servicesByCategory.services.removeWhere((s) => s.id == service.id);

    final index = servicesByCategoryInScreen.services.indexWhere((s) => s.id == service.id);
    _removeFocusOfWidgets();
    servicesByCategoryInScreen.services.removeAt(index);
    listServicesShowAll.removeAt(index);
  }

  void removeServiceOfDatabase({required Service service}) {
    context.read<ShowAllServicesViewModel>().delete(service: service);
  }

  Widget _itemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    if (listServicesShowAll.length == 0) {
      return Container();
    }
    if (index == listServicesShowAll.length) {
      return const SizedBox(
        key: ValueKey('penultimate item key'),
        height: 200,
      );
    }
    if (index == listServicesShowAll.length + 1) {
      return const SizedBox(
        key: ValueKey('last item key'),
        height: 200,
      );
    }
    if (index > listServicesShowAll.length + 1) {
      return Container();
    }
    return ServiceCard(
      key: ValueKey(listServicesShowAll[index].id),
      onTap: () {
        _onEditService(service: listServicesShowAll[index]);
      },
      onLongPress: () {
        _onRemoveService(service: listServicesShowAll[index]);
      },
      service: listServicesShowAll[index],
      animation: animation,
    );
  }

  Widget _buildRemovedItem(
    Service service,
    BuildContext context,
    Animation<double> animation,
  ) {
    return ServiceCard(
      key: ValueKey(service.id),
      onTap: () {},
      onLongPress: () {},
      service: service,
      animation: animation,
    );
  }

  void onFilter(String textValue) {
    showAllServicesViewModel.refreshValuesOfState(
      servicesByCategory: servicesByCategory,
      servicesByCategoryFiltered: servicesByCategoryInScreen,
    );
    showAllServicesViewModel.filter(textFilter: textValue);
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

  void _removeFocusOfWidgets() {
    focusNodeSearchText.unfocus();
  }
}
