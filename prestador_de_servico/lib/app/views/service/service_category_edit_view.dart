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
import 'package:prestador_de_servico/app/views/service/widgets/custom_text_name.dart';
import 'package:provider/provider.dart';

class ServiceCategoryEditView extends StatefulWidget {
  final ServiceCategory? serviceCategory;
  const ServiceCategoryEditView({super.key, this.serviceCategory});

  @override
  State<ServiceCategoryEditView> createState() => _ServiceCategoryEditViewState();
}

class _ServiceCategoryEditViewState extends State<ServiceCategoryEditView> {
  late final ServiceCategoryEditViewModel categoryEditViewModel;

  @override
  void initState() {
    categoryEditViewModel = ServiceCategoryEditViewModel(
      serviceCategoryService: context.read<ServiceCategoryService>(),
      serviceCategory: widget.serviceCategory,
    );

    categoryEditViewModel.editSuccessful.addListener(() {
      if (categoryEditViewModel.editSuccessful.value) {
        Navigator.pop(context, categoryEditViewModel.serviceCategory!);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    categoryEditViewModel.dispose();
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
              listenable: categoryEditViewModel,
              builder: (context, _) {
                if (categoryEditViewModel.categoryLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }

                Widget genericErrorWidget = const SizedBox(height: 18);
                if (categoryEditViewModel.genericErrorMessage != null) {
                  genericErrorWidget = CustomTextError(message: categoryEditViewModel.genericErrorMessage!);
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: (categoryEditViewModel.isUpdate ? 'Alterando categoria' : 'Nova categoria'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              categoryEditViewModel.isUpdate
                                  ? CustomTextName(text: categoryEditViewModel.serviceCategory!.name)
                                  : const SizedBox(),
                              categoryEditViewModel.isUpdate ? const SizedBox(height: 12) : const SizedBox(),
                              CustomTextField(
                                label: 'Nome',
                                controller: categoryEditViewModel.nameController,
                                errorMessage: categoryEditViewModel.nameErrorMessage,
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
        listenable: categoryEditViewModel,
        builder: (context, _) {
          if (categoryEditViewModel.categoryLoading || categoryEditViewModel.editSuccessful.value) {
            return const SizedBox();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 44,
              vertical: 10,
            ),
            child: CustomButton(
              label: 'Salvar',
              onTap: categoryEditViewModel.save,
            ),
          );
        },
      ),
    );
  }
}
