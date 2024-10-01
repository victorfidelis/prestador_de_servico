import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/search_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';
import 'package:prestador_de_servico/app/states/service/service_category_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/service_category_card.dart';
import 'package:provider/provider.dart';

class ServiceCategoryView extends StatefulWidget {
  const ServiceCategoryView({super.key});

  @override
  State<ServiceCategoryView> createState() => _ServiceCategoryViewState();
}

class _ServiceCategoryViewState extends State<ServiceCategoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<ServiceCategoryController>().load());
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
          Consumer<ServiceCategoryController>(
              builder: (context, serviceCategoryController, _) {
            if (serviceCategoryController.state is ServiceCategoryInitial) {
              return const SliverFillRemaining();
            }

            if (serviceCategoryController.state is ServiceCategoryError) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                      (serviceCategoryController.state as ServiceCategoryError)
                          .message),
                ),
              );
            }

            if (serviceCategoryController.state is ServiceCategoryLoading) {
              return const SliverFillRemaining(
                child: Center(
                  child: CustomLoading(),
                ),
              );
            }

            List<ServiceCategoryModel> serviceCategories =
                (serviceCategoryController.state as ServiceCategoryLoaded)
                    .serviceCategories;

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
                          serviceCategory: serviceCategories[index],
                        ),
                        Divider(color: Theme.of(context).colorScheme.shadow),
                      ],
                    );
                  },
                  childCount: serviceCategories.length,
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
          onTap: () {
            Navigator.of(context).pushNamed('/serviceCategoryEdit');
          },
        ),
      ),
    );
  }

  void goAddServiceCategory() {
    context.read<ServiceCategoryEditController>().initAdd();
    Navigator.of(context).pushNamed('/serviceCategoryEdit');
  }

  void goUpdateServiceCategory({required ServiceCategoryModel serviceCategory}) {
    context.read<ServiceCategoryEditController>().initUpdate(serviceCategory: serviceCategory,);
    Navigator.of(context).pushNamed('/serviceCategoryEdit');
  }
}
