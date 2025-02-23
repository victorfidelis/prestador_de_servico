import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/service/viewmodels/service_edit_viewmodel.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/hours_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/minutes_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/money_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_image_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_error.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/views/service/states/service_edit_state.dart';
import 'package:prestador_de_servico/app/views/service/widgets/custom_text_name.dart';
import 'package:provider/provider.dart';

class ServiceEditView extends StatefulWidget {
  const ServiceEditView({super.key});

  @override
  State<ServiceEditView> createState() => _ServiceEditViewState();
}

class _ServiceEditViewState extends State<ServiceEditView> {
  final CustomNotifications _notifications = CustomNotifications();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  String? imageUrl;
  File? imageFile;

  final FocusNode nameFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode hoursFocus = FocusNode();
  final FocusNode minutesFocus = FocusNode();

  late bool isUpdate;

  late ServiceCategory serviceCategory;
  Service? service;

  @override
  void initState() {
    isUpdate = (context.read<ServiceEditViewModel>().state is ServiceEditUpdate);
    if (isUpdate) {
      final updateState = (context.read<ServiceEditViewModel>().state as ServiceEditUpdate);
      serviceCategory = updateState.serviceCategory;
      service = updateState.service;
      _loadFieldsWithService(service: service!);
    } else {
      final insertState = (context.read<ServiceEditViewModel>().state as ServiceEditAdd);
      serviceCategory = insertState.serviceCategory;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            Consumer<ServiceEditViewModel>(builder: (context, serviceEditViewModel, _) {
              if (serviceEditViewModel.state is ServiceEditSuccess) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    Service service = (serviceEditViewModel.state as ServiceEditSuccess).service;
                    Navigator.pop(context, service);
                  },
                );
                return Container();
              }
        
              if (serviceEditViewModel.state is ServiceEditLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CustomLoading(),
                  ),
                );
              } 
        
              if (serviceEditViewModel.state is PickImageError) {
                final pickImageErroState = (serviceEditViewModel.state as PickImageError);
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    _notifications.showSnackBar(context: context, message: pickImageErroState.message);
                  },
                );
              }
        
              if (serviceEditViewModel.state is PickImageSuccess) {
                final pickImageSuccessState = (serviceEditViewModel.state as PickImageSuccess);
                imageFile = pickImageSuccessState.imageFile;
              }
        
              String? nameErrorMessage;
              String? priceErrorMessage;
              String? hoursAndMinutesErrorMessage;
              String? genericErrorMessage;
              Widget genericErrorWidget = const SizedBox(height: 18);
        
              if (serviceEditViewModel.state is ServiceEditError) {
                nameErrorMessage = (serviceEditViewModel.state as ServiceEditError).nameMessage;
                priceErrorMessage = (serviceEditViewModel.state as ServiceEditError).priceMessage;
                hoursAndMinutesErrorMessage = (serviceEditViewModel.state as ServiceEditError).hoursAndMinutesMessage;
                genericErrorMessage = (serviceEditViewModel.state as ServiceEditError).genericMessage;
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
                            isNumeric: true,
                            inputFormatters: [MoneyTextInputFormatter()],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Horas',
                                  controller: hoursController,
                                  focusNode: hoursFocus,
                                  isNumeric: true,
                                  inputFormatters: [HoursTextInputFormatter()],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Minutos',
                                  controller: minutesController,
                                  focusNode: minutesFocus,
                                  isNumeric: true,
                                  inputFormatters: [MinutesTextInputFormatter()],
                                ),
                              ),
                            ],
                          ),
                          hoursAndMinutesErrorMessage == null ? Container() : 
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                const SizedBox(height: 16),
                                CustomTextError(message: hoursAndMinutesErrorMessage),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomImageField(
                            onTap: onSelectImage,
                            label: 'Imagem',
                            imageUrl: imageUrl,
                            imageFile: imageFile,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<ServiceEditViewModel>(
        builder: (context, serviceEditViewModel, _) {
          if (serviceEditViewModel.state is ServiceEditLoading || serviceEditViewModel.state is ServiceEditSuccess) {
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

  void _loadFieldsWithService({required Service service}) {
      nameController.text = service.name;
      priceController.text = service.price.toString().replaceAll('.', ',');
      if (service.hours == 0) {
        hoursController.text = '';
      }
      else {
        hoursController.text = service.hours.toString();
      }
      if (service.minutes == 0) {
        minutesController.text = '';
      } else {
        minutesController.text = service.minutes.toString();
      }
      if (service.imageUrl.isNotEmpty) {
        imageUrl = service.imageUrl;
      }
  }

  void save() {
    Service serviceEdit = _createServiceObject();

    if (isUpdate) {
      context.read<ServiceEditViewModel>().validateAndUpdate(service: serviceEdit);
    } else {
      context.read<ServiceEditViewModel>().validateAndInsert(service: serviceEdit);
    }
  } 

  Service _createServiceObject() {
    final id = service?.id ?? '';
    final serviceCategoryId = serviceCategory.id;
    final name = nameController.text.trim();
    
    var textPrice = priceController.text.trim().replaceAll(',', '.');
    if (textPrice.endsWith('.')) {
      textPrice += '0';
    }
    if (textPrice.isEmpty) {
      textPrice = '0';
    }
    final price = double.parse(textPrice);
    
    var textHours = hoursController.text.trim();
    if (textHours.isEmpty) {
      textHours = '0';
    }
    final hours = int.parse(textHours);
    
    var textMinutes = minutesController.text.trim();
    if (textMinutes.isEmpty) {
      textMinutes = '0';
    }
    final minutes = int.parse(textMinutes); 

    return Service(
      id: id,
      serviceCategoryId: serviceCategoryId,
      name: name,
      price: price,
      hours: hours,
      minutes: minutes,
      imageUrl: imageUrl ?? '',
      imageFile: imageFile,
    );
  }

  void onSelectImage() {
    context.read<ServiceEditViewModel>().pickImageFromGallery();
  }
}
