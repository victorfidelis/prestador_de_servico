import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/offline_image/offline_image_service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/hours_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/minutes_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/money_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_image_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/service/widgets/custom_text_name.dart';
import 'package:provider/provider.dart';

class ServiceEditView extends StatefulWidget {
  final ServiceCategory serviceCategory;
  final Service? service;
  const ServiceEditView({
    super.key,
    required this.serviceCategory,
    this.service,
  });

  @override
  State<ServiceEditView> createState() => _ServiceEditViewState();
}

class _ServiceEditViewState extends State<ServiceEditView> {
  late final ServiceEditViewModel serviceEditViewModel;

  @override
  void initState() {
    serviceEditViewModel = ServiceEditViewModel(
      offlineImageService: context.read<OfflineImageService>(),
      serviceService: context.read<ServiceService>(),
      serviceCategory: widget.serviceCategory,
      service: widget.service,
    );

    serviceEditViewModel.notificationMessage.addListener(() {
      if (serviceEditViewModel.notificationMessage.value != null) {
        CustomNotifications().showSnackBar(context: context, message: serviceEditViewModel.notificationMessage.value!);
      }
    });

    serviceEditViewModel.editSuccessful.addListener(() {
      if (serviceEditViewModel.editSuccessful.value) {
        Navigator.pop(context, serviceEditViewModel.service!);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    serviceEditViewModel.dispose();
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
              listenable: serviceEditViewModel,
              builder: (context, _) {
                if (serviceEditViewModel.serviceEditLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomLoading(),
                    ),
                  );
                }

                Widget genericErrorWidget = const SizedBox(height: 18);
                if (serviceEditViewModel.genericErrorMessage != null) {
                  genericErrorWidget = CustomTextError(message: serviceEditViewModel.genericErrorMessage!);
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(
                                text: (serviceEditViewModel.isUpdate ? 'Alterando categoria' : 'Nova categoria')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              serviceEditViewModel.isUpdate
                                  ? CustomTextName(text: serviceEditViewModel.service!.name)
                                  : const SizedBox(),
                              serviceEditViewModel.isUpdate ? const SizedBox(height: 12) : const SizedBox(),
                              CustomTextField(
                                label: 'Nome',
                                controller: serviceEditViewModel.nameController,
                                errorMessage: serviceEditViewModel.nameErrorMessage,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                label: 'Valor',
                                controller: serviceEditViewModel.priceController,
                                errorMessage: serviceEditViewModel.priceErrorMessage,
                                isNumeric: true,
                                inputFormatters: [MoneyTextInputFormatter()],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Horas',
                                      controller: serviceEditViewModel.hoursController,
                                      isNumeric: true,
                                      inputFormatters: [HoursTextInputFormatter()],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Minutos',
                                      controller: serviceEditViewModel.minutesController,
                                      isNumeric: true,
                                      inputFormatters: [MinutesTextInputFormatter()],
                                    ),
                                  ),
                                ],
                              ),
                              serviceEditViewModel.hoursAndMinutesErrorMessage == null
                                  ? const SizedBox()
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        CustomTextError(message: serviceEditViewModel.hoursAndMinutesErrorMessage!),
                                      ],
                                    ),
                              const SizedBox(height: 20),
                              CustomImageField(
                                onTap: serviceEditViewModel.pickImageFromGallery,
                                label: 'Imagem',
                                imageUrl: serviceEditViewModel.imageUrl,
                                imageFile: serviceEditViewModel.imageFile,
                              ),
                              const SizedBox(height: 150),
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
        listenable: serviceEditViewModel,
        builder: (context, _) {
          if (serviceEditViewModel.serviceEditLoading) {
            return const SizedBox();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 44,
              vertical: 10,
            ),
            child: CustomButton(
              label: 'Salvar',
              onTap: serviceEditViewModel.saveService,
            ),
          );
        },
      ),
    );
  }
}
