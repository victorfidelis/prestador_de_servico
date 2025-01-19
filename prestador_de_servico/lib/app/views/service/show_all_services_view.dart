import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/show_all_services_controller.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/shared/helpers/custom_sliver_animated_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
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
  final GlobalKey<SliverAnimatedListState> _animatedListKey = GlobalKey<SliverAnimatedListState>();
  late CustomSliverAnimatedList<Service> _listServices;
  final _scrollController = ScrollController();
  final focusNodeSearchText = FocusNode();

  @override
  void initState() {
    _listServices = CustomSliverAnimatedList<Service>(
      listKey: _animatedListKey,
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

              final serviceCategory =
                  (showAllServicesController.state as ShowAllServicesLoaded).servicesByCategories.serviceCategory;

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
                    (showAllServicesController.state as ShowAllServicesLoaded).servicesByCategories.services);
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                sliver: SliverAnimatedGrid(
                  key: _animatedListKey,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 2
                  ),
                  initialItemCount: _listServices.length + 2,
                  itemBuilder: _itemBuilder,
                ),
              );
            },
          ),
        ],
      ),
    );
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
      onTap: () {},
      onLongPress: () {},
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
}
