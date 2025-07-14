import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_with_search.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/show_all_services_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/shared/animated_collections_helpers/sliver_animated_grid_helper.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';
import 'package:provider/provider.dart';

class ShowAllServicesView extends StatefulWidget {
  final ServiceCategory serviceCategory;
  final Function({required Service service}) removeServiceOfOtherScreen;
  final Function({required Service service}) addServiceOfOtherScreen;
  final Function({required Service service}) editServiceOfOtherScreen;

  const ShowAllServicesView({
    super.key,
    required this.serviceCategory,
    required this.removeServiceOfOtherScreen,
    required this.addServiceOfOtherScreen,
    required this.editServiceOfOtherScreen,
  });

  @override
  State<ShowAllServicesView> createState() => _ShowAllServicesViewState();
}

class _ShowAllServicesViewState extends State<ShowAllServicesView> {
  late final ShowAllServicesViewModel showAllServicesViewModel;
  final GlobalKey<SliverAnimatedGridState> animatedGridKey = GlobalKey<SliverAnimatedGridState>();
  late SliverAnimatedGridHelper<Service> listServicesShowAll;
  final scrollController = ScrollController();
  final focusNodeSearchText = FocusNode();

  @override
  void initState() {
    showAllServicesViewModel = ShowAllServicesViewModel(
      serviceService: context.read<ServiceService>(),
      serviceCategory: widget.serviceCategory,
    );

    listServicesShowAll = SliverAnimatedGridHelper<Service>(
      gridKey: animatedGridKey,
      removedItemBuilder: _removedItemBuilder,
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
                onSearch: _onSearch,
                focusNode: focusNodeSearchText,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 18,
              ),
              sliver: SliverToBoxAdapter(
                child: ListenableBuilder(
                    listenable: showAllServicesViewModel,
                    builder: (context, _) {
                      return Text(
                        showAllServicesViewModel.serviceCategory.name,
                        style: const TextStyle(fontSize: 18),
                      );
                    }),
              ),
            ),
            ListenableBuilder(
              listenable: showAllServicesViewModel,
              builder: (context, _) {
                if (showAllServicesViewModel.hasServiceError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(showAllServicesViewModel.serviceErrorMessage!),
                    ),
                  );
                }

                if (showAllServicesViewModel.serviceLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }

                if (showAllServicesViewModel.serviceFiltered) {
                  listServicesShowAll.removeAndInsertAll(List.from(showAllServicesViewModel.servicesFiltered));
                } else {
                  listServicesShowAll.removeAndInsertAll(List.from(showAllServicesViewModel.serviceCategory.services));
                }

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
        .pushNamed('/serviceEdit', arguments: {'serviceCategory': showAllServicesViewModel.serviceCategory});
    if (result != null) {
      final serviceAdd = result as Service;
      widget.addServiceOfOtherScreen(service: serviceAdd);
      _addService(service: serviceAdd);
    }
  }

  Future<void> _addService({required Service service}) async {
    final hasService = listServicesShowAll.length > 0;
    if (hasService) await _scrollToEnd();
    showAllServicesViewModel.addService(service: service);
    listServicesShowAll.insert(service);
  }

  Future<void> _onEditService({required Service service, required int index}) async {
    _removeFocusOfWidgets();

    final result = await Navigator.of(context).pushNamed(
      '/serviceEdit',
      arguments: {
        'serviceCategory': showAllServicesViewModel.serviceCategory,
        'service': service,
      },
    );

    if (result != null) {
      final serviceEdited = result as Service;
      widget.editServiceOfOtherScreen(service: serviceEdited);
      _editService(service: serviceEdited, index: index);
    }
  }

  void _editService({required Service service, required int index}) {
    showAllServicesViewModel.editService(service: service);
    listServicesShowAll.removeAt(index, 0);
    listServicesShowAll.insertAt(index, service);
  }

  void _onRemoveService({required Service service, required int index}) {
    CustomNotifications().showQuestionAlert(
      context: context,
      title: 'Excluir serviço',
      content: 'Tem certeza que deseja excluir serviço?',
      confirmCallback: () {
        widget.removeServiceOfOtherScreen(service: service);
        _removeService(service: service, index: index);
      },
    );
  }

  void _removeService({required Service service, required int index}) {
    showAllServicesViewModel.delete(service: service);
    _removeFocusOfWidgets();
    listServicesShowAll.removeAt(index);
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
        _onEditService(service: listServicesShowAll[index], index: index);
      },
      onLongPress: () {
        _onRemoveService(service: listServicesShowAll[index], index: index);
      },
      service: listServicesShowAll[index],
      animation: animation,
    );
  }

  Widget _removedItemBuilder(
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

  void _onSearch(String textValue) {
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
