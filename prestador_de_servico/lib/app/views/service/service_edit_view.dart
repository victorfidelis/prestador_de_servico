import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/controllers/service/service_edit_controller.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_image_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/states/service/service_edit_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/custom_text_name.dart';
import 'package:provider/provider.dart';

class ServiceEditView extends StatefulWidget {
  const ServiceEditView({super.key});

  @override
  State<ServiceEditView> createState() => _ServiceEditViewState();
}

class _ServiceEditViewState extends State<ServiceEditView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode hoursFocus = FocusNode();
  final FocusNode minutesFocus = FocusNode();

  late bool isUpdate;

  late ServiceCategory serviceCategory;
  Service? service;

  @override
  void initState() {
    isUpdate = (context.read<ServiceEditController>().state is ServiceEditUpdate);
    if (isUpdate) {
      final updateState = (context.read<ServiceEditController>().state as ServiceEditUpdate);
      serviceCategory = updateState.serviceCategory;
      service = updateState.service;
      nameController.text = service!.name;
    } else {
      final insertState = (context.read<ServiceEditController>().state as ServiceEditAdd);
      serviceCategory = insertState.serviceCategory;
    }
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
                  SizedBox(width: 60, child: BackNavigation(onTap: () => Navigator.pop(context))),
                  const Expanded(child: CustomAppBarTitle(title: 'Serviços')),
                  const SizedBox(width: 60),
                ],
              ),
            ),
          ),
          Consumer<ServiceEditController>(builder: (context, serviceEditController, _) {
            if (serviceEditController.state is ServiceEditSuccess) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Service service = (serviceEditController.state as ServiceEditSuccess).service;
                  Navigator.pop(context, service);
                },
              );
              return Container();
            }

            if (serviceEditController.state is ServiceEditLoading) {
              return const Expanded(
                child: Center(
                  child: CustomLoading(),
                ),
              );
            }

            String? nameErrorMessage;
            String? priceErrorMessage;
            String? hoursAndMinutesErrorMessage;
            String? genericErrorMessage;
            Widget genericErrorWidget = const SizedBox(height: 18);

            if (serviceEditController.state is ServiceEditError) {
              nameErrorMessage = (serviceEditController.state as ServiceEditError).nameMessage;
              priceErrorMessage = (serviceEditController.state as ServiceEditError).priceMessage;
              hoursAndMinutesErrorMessage = (serviceEditController.state as ServiceEditError).hoursAndMinutesMessage;
              genericErrorMessage = (serviceEditController.state as ServiceEditError).genericMessage;
              if (genericErrorMessage != null) {
                genericErrorWidget = CustomTextError(message: genericErrorMessage);
              }
            }

            return Padding(
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
                        isUpdate ? CustomTextName(text: service!.name) : Container(),
                        isUpdate ? const SizedBox(height: 12) : Container(),
                        CustomTextField(
                          label: 'Nome',
                          controller: nameController,
                          focusNode: nameFocus,
                          errorMessage: nameErrorMessage,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Valor',
                          controller: priceController,
                          focusNode: priceFocus,
                          errorMessage: priceErrorMessage,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'Horas',
                                controller: hoursController,
                                focusNode: hoursFocus,
                                errorMessage: null,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: CustomTextField(
                                label: 'Minutos',
                                controller: minutesController,
                                focusNode: minutesFocus,
                                errorMessage: null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const CustomImageField(
                          label: 'Imagem',
                          urlImage: 'https://cdn.pixabay.com/photo/2022/10/17/09/41/twig-7527181_1280.jpg',
                        )
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
      floatingActionButton: Consumer<ServiceEditController>(
        builder: (context, serviceEditController, _) {
          if (serviceEditController.state is ServiceEditLoading || serviceEditController.state is ServiceEditSuccess) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 44,
              vertical: 10,
            ),
            child: CustomButton(
              label: 'Salvar',
              onTap: save,
            ),
          );
        },
      ),
    );
  }

  void save() {
    Service serviceEdit = Service(
      id: service?.id ?? '',
      serviceCategoryId: serviceCategory.id,
      name: nameController.text,
      price: double.parse(priceController.text),
      hours: int.parse(hoursController.text),
      minutes: int.parse(minutesController.text),
      urlImage: '',
    );

    if (isUpdate) {
      context.read<ServiceEditController>().validateAndUpdate(service: serviceEdit);
    } else {
      context.read<ServiceEditController>().validateAndInsert(service: serviceEdit);
    }
  }
}
