import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_controller.dart';
import 'package:prestador_de_servico/app/controllers/service/service_category_edit_controller.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/states/service/service_category_edit_state.dart';
import 'package:provider/provider.dart';

class ServiceCategoryEditView extends StatefulWidget {
  const ServiceCategoryEditView({super.key});

  @override
  State<ServiceCategoryEditView> createState() =>
      _ServiceCategoryEditViewState();
}

class _ServiceCategoryEditViewState extends State<ServiceCategoryEditView> {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  late bool isNew;
  
  @override
  void initState() {
    isNew = (context.read<ServiceCategoryEditController>().state is ServiceCategoryEditAdd);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeaderContainer(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  SizedBox(
                      width: 60,
                      child:
                          BackNavigation(onTap: () => Navigator.pop(context))),
                  const Expanded(child: CustomAppBarTitle(title: 'Serviços')),
                  const SizedBox(width: 60),
                ],
              ),
            ),
          ),
          Consumer<ServiceCategoryEditController>(
              builder: (context, serviceCategoryEditController, _) {
            if (serviceCategoryEditController.state
                is ServiceCategoryEditSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ServiceCategoryModel serviceCategory =
                    (serviceCategoryEditController.state
                            as ServiceCategoryEditSuccess)
                        .serviceCategory;
                context
                    .read<ServiceCategoryController>()
                    .insert(serviceCategory: serviceCategory);
                Navigator.pop(context);
              });
              return Container();
            }

            if (serviceCategoryEditController.state
                is ServiceCategoryEditLoading) {
              return const Expanded(
                child: Center(
                  child: CustomLoading(),
                ),
              );
            }

            String? nameErrorMessage;
            String? genericErrorMessage;
            Widget genericErrorWidget = const SizedBox(height: 18);

            if (serviceCategoryEditController.state
                is ServiceCategoryEditError) {
              nameErrorMessage = (serviceCategoryEditController.state
                      as ServiceCategoryEditError)
                  .nameMessage;
              genericErrorMessage = (serviceCategoryEditController.state
                      as ServiceCategoryEditError)
                  .genericMessage;
              if (genericErrorMessage != null) {
                genericErrorWidget =
                    CustomTextError(message: genericErrorMessage);
              }
            }

            

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Column(
                children: [
                  const Row(
                    children: [
                      CustomText(text: 'Nova categoria'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Nome',
                          controller: nameController,
                          focusNode: nameFocus,
                          errorMessage: nameErrorMessage,
                        ),
                      ],
                    ),
                  ),
                  genericErrorWidget,
                ],
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
          label: 'Salvar',
          onTap: saveServiceCategory,
        ),
      ),
    );
  }

  void saveServiceCategory() {
    context
        .read<ServiceCategoryEditController>()
        .add(name: nameController.text);
  }
}
