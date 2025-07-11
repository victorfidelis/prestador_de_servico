import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/scheduling/scheduling.dart';
import 'package:prestador_de_servico/app/repositories/image/image_repository.dart';
import 'package:prestador_de_servico/app/repositories/scheduling/scheduling_repository.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/states/scheduling/scheduling_state.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/utils/text_input_fomatters/time_text_input_formatter.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/scheduling/scheduling_viewmodel.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_scheduling_card.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_data.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_filed_underline.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notifications.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/states/edit_date_and_time_state.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/edit_date_and_time_viewmodel.dart';
import 'package:provider/provider.dart';

class EditDateAndTimeView extends StatefulWidget {
  final Scheduling scheduling;
  const EditDateAndTimeView({super.key, required this.scheduling});

  @override
  State<EditDateAndTimeView> createState() => _EditDateAndTimeViewState();
}

class _EditDateAndTimeViewState extends State<EditDateAndTimeView> {
  late EditDateAndTimeViewModel editDateAndTimeViewModel;
  late SchedulingViewModel schedulingViewModel;
  final CustomNotifications customNotifications = CustomNotifications();

  late Scheduling scheduling;
  final TextEditingController dateController = TextEditingController();
  final FocusNode dateFocus = FocusNode();
  final TextEditingController timeController = TextEditingController();
  final FocusNode timeFocus = FocusNode();

  @override
  void initState() {
    scheduling = widget.scheduling;
    schedulingViewModel = SchedulingViewModel(
      schedulingService: context.read<SchedulingService>(),
    );
    editDateAndTimeViewModel = EditDateAndTimeViewModel(
      schedulingService: SchedulingService(
          onlineRepository: SchedulingRepository.createOnline(), imageRepository: ImageRepository.create()),
    );
    editDateAndTimeViewModel.setServiceTime(scheduling.serviceTime);
    editDateAndTimeViewModel.setSchedulingId(scheduling.id);
    super.initState();
  }

  @override
  void dispose() {
    editDateAndTimeViewModel.dispose();
    schedulingViewModel.dispose();
    dateController.dispose();
    timeController.dispose();
    dateFocus.dispose();
    timeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = ColorsUtils.getColorFromStatus(context, scheduling.serviceStatus);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, hasChange) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, hasChange as bool?);
      },
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverFloatingHeader(child: CustomHeader(title: 'Alteração de Agendamento', height: 100)),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheduling.user.fullname,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        scheduling.serviceStatus.name,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(color: Theme.of(context).colorScheme.shadow),
                      const SizedBox(height: 8),
                      const Text(
                        'Data atual',
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Formatters.defaultFormatDate(scheduling.startDateAndTime),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'das',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  Formatters.defaultFormatHoursAndMinutes(
                                    scheduling.startDateAndTime.hour,
                                    scheduling.startDateAndTime.minute,
                                  ),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'às',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  Formatters.defaultFormatHoursAndMinutes(
                                    scheduling.endDateAndTime.hour,
                                    scheduling.endDateAndTime.minute,
                                  ),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(color: Theme.of(context).colorScheme.shadow),
                      const SizedBox(height: 8),
                      ListenableBuilder(
                        listenable: editDateAndTimeViewModel.schedulingDateError,
                        builder: (context, _) {
                          return CustomTextData(
                            label: 'Nova data',
                            controller: dateController,
                            onTap: _getNewDate,
                            errorMessage: editDateAndTimeViewModel.schedulingDateError.value,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Novo horário',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            const Text('Das'),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ListenableBuilder(
                                  listenable: editDateAndTimeViewModel.startTimeError,
                                  builder: (context, _) {
                                    return CustomTextFieldUnderline(
                                      controller: timeController,
                                      focusNode: timeFocus,
                                      inputFormatters: [TimeTextInputFormatter()],
                                      onChanged: (value) => editDateAndTimeViewModel.setStartTime(value),
                                      errorMessage: editDateAndTimeViewModel.startTimeError.value,
                                      isNumeric: true,
                                    );
                                  }),
                            ),
                            const SizedBox(width: 12),
                            const Text('às'),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ListenableBuilder(
                                listenable: editDateAndTimeViewModel.endTime,
                                builder: (context, _) {
                                  return Text(
                                    editDateAndTimeViewModel.endTime.value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 6)),
              SliverToBoxAdapter(child: Divider(color: Theme.of(context).colorScheme.shadow)),
              const SliverToBoxAdapter(child: SizedBox(height: 6)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Agendamentos',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ListenableBuilder(
                        listenable: editDateAndTimeViewModel.schedulingDate,
                        builder: (context, _) {
                          if (editDateAndTimeViewModel.schedulingDate.value == null) {
                            return const SizedBox();
                          }
                          return Text(
                            Formatters.defaultFormatDate(editDateAndTimeViewModel.schedulingDate.value!),
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 6)),
              ListenableBuilder(
                listenable: schedulingViewModel,
                builder: (context, _) {
                  if (schedulingViewModel.state is SchedulingInitial) {
                    return const SliverToBoxAdapter();
                  }
          
                  if (schedulingViewModel.state is SchedulingLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CustomLoading()),
                    );
                  }
          
                  final schedules = (schedulingViewModel.state as SchedulingLoaded).schedules;
          
                  if (schedules.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            'Nenhum serviço agendado',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.shadow,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
          
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.builder(
                      itemCount: schedules.length + 1,
                      itemBuilder: (context, index) {
                        if (index == schedules.length) {
                          return const SizedBox(height: 150);
                        }
          
                        return CustomSchedulingCard(
                          scheduling: schedules[index],
                          isReadOnly: true,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListenableBuilder(
            listenable: editDateAndTimeViewModel,
            builder: (context, _) {
              if (editDateAndTimeViewModel.state is EditDateAndTimeLoading) {
                return const CustomLoading();
              }

              if (editDateAndTimeViewModel.state is EditDateAndTimeError) {
                final messageError = (editDateAndTimeViewModel.state as EditDateAndTimeError).message;
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => customNotifications.showSnackBar(
                    context: context,
                    message: messageError,
                  ),
                );
              }

              if (editDateAndTimeViewModel.state is EditDateAndTimeUpdateSuccess) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pop(context, true),
                );
              }

              return CustomButton(
                label: 'Salvar',
                onTap: _onSave,
              );
            },
          ),
        ),
      ),
    );
  }

  void _getNewDate() async {
    timeFocus.unfocus();
    final actualDate = DateTime.now();
    final firstDate = DateTime(actualDate.year, actualDate.month, actualDate.day);
    final lastDate = firstDate.add(const Duration(days: 90));
    final DateTime selectedDate;
    if (dateController.text.isNotEmpty) {
      selectedDate = Formatters.dateFromDefaultDateText(dateController.text);
    } else {
      selectedDate = actualDate;
    }

    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (newDate == null) {
      return;
    }
    dateController.text = Formatters.defaultFormatDate(newDate);
    schedulingViewModel.load(dateTime: newDate);
    editDateAndTimeViewModel.setSchedulingDate(newDate);
  }

  Future<void> _onSave() async {
    timeFocus.unfocus();
    if (!editDateAndTimeViewModel.validate()) {
      return;
    }
    await _confirmSave();
  }

  Future<void> _confirmSave() async {
    final dateText = Formatters.defaultFormatDate(editDateAndTimeViewModel.schedulingDate.value!);
    final hourText = editDateAndTimeViewModel.startTime;
    final String dateHourText = '$dateText $hourText';

    await customNotifications.showQuestionAlert(
      context: context,
      title: 'Alterar data e hora',
      content: 'Tem certeza que deseja alterar a data e a hora do serviço para "$dateHourText"?',
      confirmCallback: () {
        editDateAndTimeViewModel.save();
      },
    );
  }
}
