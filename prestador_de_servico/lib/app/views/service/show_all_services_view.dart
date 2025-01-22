import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_edit_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/show_all_services_controller.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/services_by_category/services_by_category.dart';
import 'package:prestador_de_servico/app/shared/helpers/custom_sliver_animated_grid.dart';
import 'package:prestador_de_servico/app/shared/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/search_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/states/service/show_all_services_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_card.dart';
import 'package:provider/provider.dart';

class ShowAllServicesView extends StatefulWidget {
  const ShowAllServicesView({super.key});

  @override
  State<ShowAllServicesView> createState() => _ShowAllServicesViewState();
}

class _ShowAllServicesViewState extends State<ShowAllServicesView> {
  late ServicesByCategory servicesByCategory;
  final GlobalKey<SliverAnimatedGridState> _animatedGridKey = GlobalKey<SliverAnimatedGridState>();
  late CustomSliverAnimatedGrid<Service> _listServices;
  final _scrollController = ScrollController();
  final focusNodeSearchText = FocusNode();
  final _customNotifications = CustomNotifications();

  @override
  void initState() {
    _listServices = CustomSliverAnimatedGrid<Service>(
      gridKey: _animatedGridKey,
      removedItemBuilder: _buildRemovedItem,
      initialItems: [],
    );
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
                      hintText: 'Pesquise por um serviço',
                      onChanged: (String value) {},
                      focusNode: focusNodeSearchText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<ShowAllServicesController>(
            builder: (context, showAllServicesController, _) {
              if (showAllServicesController.state is! ShowAllServicesLoaded) {
                return const SliverToBoxAdapter();
              }

              servicesByCategory =
                  (showAllServicesController.state as ShowAllServicesLoaded).servicesByCategory;
              final serviceCategory = servicesByCategory.serviceCategory;

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
          Consumer<ShowAllServicesController>(
            builder: (context, showAllServicesController, _) {
              if (showAllServicesController.state is ShowAllServicesController) {
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

              if (showAllServicesController.state is ShowAllServicesFiltered) {
                _listServices.removeAndInsertAll(
                    (showAllServicesController.state as ShowAllServicesFiltered).servicesByCategoriesFiltered.services);
              } else {
                _listServices.removeAndInsertAll(
                    (showAllServicesController.state as ShowAllServicesLoaded).servicesByCategory.services);
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                sliver: SliverAnimatedGrid(
                  key: _animatedGridKey,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 2),
                  initialItemCount: _listServices.length + 2,
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
    context.read<ServiceEditController>().initInsert(serviceCategory: servicesByCategory.serviceCategory);
    final result = await Navigator.of(context).pushNamed('/serviceEdit');
    if (result != null) {
      final hasService = _listServices.length > 0;

      if (hasService) await _scrollToEnd();

      final serviceInsert = result as Service;

      _listServices.insert(serviceInsert);
    }
  }

  Future<void> _onEditService({
    required Service service,
    required int index,
  }) async {
    removeFocusOfWidgets();
    context.read<ServiceEditController>().initUpdate(
          serviceCategory: servicesByCategory.serviceCategory,
          service: service,
        );
    final result = await Navigator.of(context).pushNamed('/serviceEdit');
    if (result != null) {
      final serviceEdited = result as Service;
      servicesByCategory.services[index] = serviceEdited;

      _listServices.removeAt(index, 0);
      _listServices.insertAt(index, serviceEdited);
    }
  }

  Future<void> _onRemoveService({required Service service, required int index}) async {
    _customNotifications.showQuestionAlert(
      context: context,
      title: 'Excluir serviço',
      content: 'Tem certeza que deseja excluir serviço?',
      confirmCallback: () {
        _removeService(service: service, index: index);
      },
    );
  }

  Future<void> _removeService({required Service service, required int index}) async {
    removeFocusOfWidgets();
    context.read<ServiceController>().deleteService(service: service);
    servicesByCategory.services.removeAt(index);
    _listServices.removeAt(index);
  }

  Widget _itemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    if (index == _listServices.length) {
      return const SizedBox(
        key: ValueKey('penultimate item key'),
        height: 200,
      );
    }
    if (index == _listServices.length + 1) {
      return const SizedBox(
        key: ValueKey('last item key'),
        height: 200,
      );
    }
    return ServiceCard(
      key: ValueKey(_listServices[index].id),
      onTap: () {
        _onEditService(
          service: _listServices[index],
          index: index,
        );
      },
      onLongPress: () {
        _onRemoveService(service: _listServices[index], index: index);
      },
      service: _listServices[index],
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
