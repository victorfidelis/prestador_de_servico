import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_category_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/service/states/service_category_edit_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/custom_text_name.dart';
import 'package:provider/provider.dart';

class ServiceCategoryEditView extends StatefulWidget {
  final ServiceCategory? serviceCategory;
  const ServiceCategoryEditView({super.key, this.serviceCategory});

  @override
  State<ServiceCategoryEditView> createState() => _ServiceCategoryEditViewState();
}

class _ServiceCategoryEditViewState extends State<ServiceCategoryEditView> {
  late final ServiceCategoryEditViewModel serviceCategoryEditViewModel;
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  late bool isUpdate;
  ServiceCategory? serviceCategory;

  @override
  void initState() {
    serviceCategoryEditViewModel = ServiceCategoryEditViewModel(
      serviceCategoryService: context.read<ServiceCategoryService>(),
    );

    serviceCategory = widget.serviceCategory;
    isUpdate = (serviceCategory != null);
    if (isUpdate) {
      nameController.text = serviceCategory!.name;
    }

    super.initState();
  }

  @override
  void dispose() {
    serviceCategoryEditViewModel.dispose();
    nameController.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverFloatingHeader(child: CustomHeader(title: 'Serviços')),
            ListenableBuilder(
              listenable: serviceCategoryEditViewModel,
              builder: (context, _) {
                if (serviceCategoryEditViewModel.state is ServiceCategoryEditSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ServiceCategory serviceCategory =
                        (serviceCategoryEditViewModel.state as ServiceCategoryEditSuccess).serviceCategory;
                    Navigator.pop(context, serviceCategory);
                  });
                  return const SliverToBoxAdapter();
                }
        
                if (serviceCategoryEditViewModel.state is ServiceCategoryEditLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }
        
                String? nameErrorMessage;
                String? genericErrorMessage;
                Widget genericErrorWidget = const SizedBox(height: 18);
        
                if (serviceCategoryEditViewModel.state is ServiceCategoryEditError) {
                  nameErrorMessage = (serviceCategoryEditViewModel.state as ServiceCategoryEditError).nameMessage;
                  genericErrorMessage = (serviceCategoryEditViewModel.state as ServiceCategoryEditError).genericMessage;
                  if (genericErrorMessage != null) {
                    genericErrorWidget = CustomTextError(message: genericErrorMessage);
                  }
                }
        
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(text: (isUpdate ? 'Alterando categoria' : 'Nova categoria')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              isUpdate ? CustomTextName(text: serviceCategory!.name) : Container(),
                              isUpdate ? const SizedBox(height: 12) : Container(),
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ListenableBuilder(
        listenable: serviceCategoryEditViewModel,
        builder: (context, _) {
          if (serviceCategoryEditViewModel.state is ServiceCategoryEditLoading ||
              serviceCategoryEditViewModel.state is ServiceCategoryEditSuccess) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 44,
              vertical: 10,
            ),
            child: CustomButton(
              label: 'Salvar',
              onTap: _save,
            ),
          );
        },
      ),
    );
  }

  void _save() {
    ServiceCategory serviceCategoryEdit = ServiceCategory(
      id: serviceCategory?.id ?? '',
      name: nameController.text,
    );

    if (isUpdate) {
      serviceCategoryEditViewModel.validateAndUpdate(serviceCategory: serviceCategoryEdit);
    } else {
      serviceCategoryEditViewModel.validateAndInsert(serviceCategory: serviceCategoryEdit);
    }
  }
}
