import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
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

class ServiceCategoryView extends StatefulWidget {
  const ServiceCategoryView({super.key});

  @override
  State<ServiceCategoryView> createState() => _ServiceCategoryViewState();
}

class _ServiceCategoryViewState extends State<ServiceCategoryView> {
  final CustomNotifications _notifications = CustomNotifications();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<ServiceController>().load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                              child: BackNavigation(
                                  onTap: () => Navigator.pop(context))),
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
                  child: Text(
                      (serviceCategoryController.state as ServiceError)
                          .message),
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

            List<ServicesByCategory> serviceListByCategory =
                (serviceCategoryController.state as ServiceLoaded).servicesByCategory;

            return SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Column(
                      children: [
                        ServiceCategoryCard(
                          serviceCategory: serviceListByCategory[index].serviceCategory,
                          onEdit: onEditServiceCategory,
                          onDelete: onDeleteServiceCategory,
                        ),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                      ],
                    );
                  },
                  childCount: serviceListByCategory.length,
                ),
              ),
            );
          }),
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
          onTap: onAddServiceCategory,
        ),
      ),
    );
  }

  void onAddServiceCategory() {
    context.read<ServiceCategoryEditController>().initInsert();
    Navigator.of(context).pushNamed('/serviceCategoryEdit');
  }

  void onEditServiceCategory({required ServiceCategory serviceCategory}) {
    context.read<ServiceCategoryEditController>().initUpdate(
          serviceCategory: serviceCategory,
        );
    Navigator.of(context).pushNamed('/serviceCategoryEdit');
  }

  void onDeleteServiceCategory({required ServiceCategory serviceCategory}) {
    _notifications.showQuestionAlert(
      context: context,
      title: 'Excluir categoria de serviço',
      content: 'Tem certeza que deseja excluir a categoria de serviço?',
      confirmCallback: () {
        deleteServiceCategory(serviceCategory: serviceCategory);
      },
      cancelCallback: () {},
    );
  }

  void deleteServiceCategory({required ServiceCategory serviceCategory}) {
    context.read<ServiceController>().delete(serviceCategory: serviceCategory);
  }
}
