import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/show_all_services_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/sliver_animated_grid_helper.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/search_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/views/service/states/show_all_services_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';
import 'package:provider/provider.dart';

class ShowAllServicesView extends StatefulWidget {
  final Function({required Service service}) removeServiceOfOtherScreen;
  final Function({required Service service}) addServiceOfOtherScreen;
  final Function({required Service service}) editServiceOfOtherScreen;

  const ShowAllServicesView({
    super.key,
    required this.removeServiceOfOtherScreen,
    required this.addServiceOfOtherScreen,
    required this.editServiceOfOtherScreen,
  });

  @override
  State<ShowAllServicesView> createState() => _ShowAllServicesViewState();
}

class _ShowAllServicesViewState extends State<ShowAllServicesView> {
  late ServicesByCategory servicesByCategory;
  late ServicesByCategory servicesByCategoryInScreen;
  final GlobalKey<SliverAnimatedGridState> _animatedGridKey = GlobalKey<SliverAnimatedGridState>();
  late SliverAnimatedGridHelper<Service> _listServicesShowAll;
  final _scrollController = ScrollController();
  final focusNodeSearchText = FocusNode();
  final _customNotifications = CustomNotifications();

  @override
  void initState() {
    _listServicesShowAll = SliverAnimatedGridHelper<Service>(
      gridKey: _animatedGridKey,
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
                      hintText: 'Pesquise por um serviço',
                      onChanged: _onFilter,
                      focusNode: focusNodeSearchText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<ShowAllServicesViewModel>(
            builder: (context, showAllServicesController, _) {
              if (showAllServicesController.state is! ShowAllServicesLoaded) {
                return const SliverToBoxAdapter();
              }

              final serviceCategory =
                  (showAllServicesController.state as ShowAllServicesLoaded).servicesByCategory.serviceCategory;

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
          Consumer<ShowAllServicesViewModel>(
            builder: (context, showAllServicesController, _) {
              if (showAllServicesController.state is ShowAllServicesViewModel) {
                return const SliverFillRemaining();
              }

              if (showAllServicesController.state is ShowAllServicesError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text((showAllServicesController.state as ShowAllServicesError).message),
                  ),
                );
              }

              if (showAllServicesController.state is ShowAllServicesLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CustomLoading(),
                  ),
                );
              }

              final loadedState = (showAllServicesController.state as ShowAllServicesLoaded);
              final services = loadedState.servicesByCategory.services;
              servicesByCategory = loadedState.servicesByCategory.copyWith(services: List.from(services));

              if (showAllServicesController.state is ShowAllServicesFiltered) {
                final filteredState = (showAllServicesController.state as ShowAllServicesFiltered);
                final servicesFiltered = filteredState.servicesByCategoryFiltered.services;
                servicesByCategoryInScreen =
                    filteredState.servicesByCategoryFiltered.copyWith(services: List.from(servicesFiltered));
              } else {
                servicesByCategoryInScreen =
                    servicesByCategory.copyWith(services: List.from(servicesByCategory.services));
              }

              _listServicesShowAll.removeAndInsertAll(servicesByCategoryInScreen.services);

              return SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                sliver: SliverAnimatedGrid(
                  key: _animatedGridKey,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 2),
                  initialItemCount: _listServicesShowAll.length + 2,
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
          label: 'Novo serviço',
          onTap: _onAddService,
        ),
      ),
    );
  }

  Future<void> _onAddService() async {
    removeFocusOfWidgets();
    context.read<ServiceEditViewModel>().initInsert(serviceCategory: servicesByCategory.serviceCategory);
    final result = await Navigator.of(context).pushNamed('/serviceEdit');
    if (result != null) {
      final serviceAdd = result as Service;
      widget.addServiceOfOtherScreen(service: serviceAdd);
      _addServiceOfScreen(service: serviceAdd);
    }
  }

  Future<void> _addServiceOfScreen({required Service service}) async {
    final hasService = _listServicesShowAll.length > 0;
    if (hasService) await _scrollToEnd();
    servicesByCategory.services.add(service);
    servicesByCategoryInScreen.services.add(service);
    _listServicesShowAll.insert(service);
  }

  Future<void> _onEditService({required Service service}) async {
    removeFocusOfWidgets();
    context.read<ServiceEditViewModel>().initUpdate(
          serviceCategory: servicesByCategory.serviceCategory,
          service: service,
        );

    final result = await Navigator.of(context).pushNamed('/serviceEdit');

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

    _listServicesShowAll.removeAt(indexOfListInScreen, 0);
    _listServicesShowAll.insertAt(indexOfListInScreen, service);
  }

  void _onRemoveService({required Service service}) {
    _customNotifications.showQuestionAlert(
      context: context,
      title: 'Excluir serviço',
      content: 'Tem certeza que deseja excluir serviço?',
      confirmCallback: () {
        _removeServiceOfDatabase(service: service);
        widget.removeServiceOfOtherScreen(service: service);
        _removeServiceOfScreen(service: service);
      },
    );
  }

  void _removeServiceOfScreen({required Service service}) {
    servicesByCategory.services.removeWhere((s) => s.id == service.id);

    final index = servicesByCategoryInScreen.services.indexWhere((s) => s.id == service.id);
    removeFocusOfWidgets();
    servicesByCategoryInScreen.services.removeAt(index);
    _listServicesShowAll.removeAt(index);
  }

  void _removeServiceOfDatabase({required Service service}) {
    context.read<ShowAllServicesViewModel>().delete(service: service);
  }

  Widget _itemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    if (_listServicesShowAll.length == 0) {
      return Container();
    }
    if (index == _listServicesShowAll.length) {
      return const SizedBox(
        key: ValueKey('penultimate item key'),
        height: 200,
      );
    }
    if (index == _listServicesShowAll.length + 1) {
      return const SizedBox(
        key: ValueKey('last item key'),
        height: 200,
      );
    }
    if (index > _listServicesShowAll.length + 1) {
      return Container();
    }
    return ServiceCard(
      key: ValueKey(_listServicesShowAll[index].id),
      onTap: () {
        _onEditService(service: _listServicesShowAll[index]);
      },
      onLongPress: () {
        _onRemoveService(service: _listServicesShowAll[index]);
      },
      service: _listServicesShowAll[index],
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

  void _onFilter(String textValue) {
    context.read<ShowAllServicesViewModel>().refreshValuesOfState(
          servicesByCategory: servicesByCategory,
          servicesByCategoryFiltered: servicesByCategoryInScreen,
        );
    context.read<ShowAllServicesViewModel>().filter(textFilter: textValue);
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
