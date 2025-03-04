import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_scheduling/service_scheduling.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';
import 'package:prestador_de_servico/app/shared/utils/formatters/formatters.dart';
import 'package:prestador_de_servico/app/shared/widgets/back_navigation.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_app_bar_title.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_button.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_header_container.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_text_field.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_white_buttom.dart';
import 'package:prestador_de_servico/app/shared/widgets/sliver_app_bar_delegate.dart';

class EditDateAndTimeView extends StatefulWidget {
  final ServiceScheduling serviceScheduling;
  const EditDateAndTimeView({super.key, required this.serviceScheduling});

  @override
  State<EditDateAndTimeView> createState() => _EditDateAndTimeViewState();
}

class _EditDateAndTimeViewState extends State<EditDateAndTimeView> {
  late ServiceScheduling serviceScheduling;
  final TextEditingController dateController = TextEditingController();
  final FocusNode dateFocus = FocusNode();
  final TextEditingController timeController = TextEditingController();
  final FocusNode timeFocus = FocusNode();

  @override
  void initState() {
    serviceScheduling = widget.serviceScheduling;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = ColorsUtils.getColorFromStatus(
        context, serviceScheduling.serviceStatus);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            floating: true,
            delegate: SliverAppBarDelegate(
              minHeight: 144,
              maxHeight: 144,
              child: Stack(
                children: [
                  CustomHeaderContainer(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 60,
                              child: BackNavigation(
                                  onTap: () => Navigator.pop(context))),
                          const Expanded(
                            child: CustomAppBarTitle(
                              title: 'Alteração de Agendamento',
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(width: 60)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceScheduling.user.fullname,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    serviceScheduling.serviceStatus.name,
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
                    'Data original',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Formatters.defaultFormatDate(
                              serviceScheduling.startDateAndTime),
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
                                serviceScheduling.startDateAndTime.hour,
                                serviceScheduling.startDateAndTime.minute,
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
                                serviceScheduling.endDateAndTime.hour,
                                serviceScheduling.endDateAndTime.minute,
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
                  CustomTextField(
                      label: 'Nova data',
                      controller: dateController,
                      focusNode: dateFocus),
                  const SizedBox(height: 8),
                  CustomTextField(
                      label: 'Novo horário',
                      controller: timeController,
                      focusNode: timeFocus),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomButton(
          label: 'Salvar',
          onTap: () {},
        ),
      ),
    );
  }
}

