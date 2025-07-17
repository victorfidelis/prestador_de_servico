import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_empty_list.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_loading.dart';
import 'package:prestador_de_servico/app/shared/widgets/custom_scheduling_card.dart';
import 'package:prestador_de_servico/app/shared/widgets/scheduling_list/viewmodel/scheduling_list_viewmodel.dart';
import 'package:provider/provider.dart';

class SliverSchedulingList extends StatefulWidget {
  final DateTime date;
  final Function()? onSchedulingChanged;
  final bool isReadOnly;

  const SliverSchedulingList({super.key, required this.date, this.onSchedulingChanged, this.isReadOnly = false});

  @override
  State<SliverSchedulingList> createState() => _SliverSchedulingListState();
}

class _SliverSchedulingListState extends State<SliverSchedulingList> {
  late final SchedulingListViewModel schedulingListViewModel;

  @override
  void initState() {
    schedulingListViewModel = SchedulingListViewModel(
      schedulingService: context.read<SchedulingService>(),
    );
    super.initState();
  }

  @override
  void dispose() {
    schedulingListViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    schedulingListViewModel.load(dateTime: widget.date);

    return ListenableBuilder(
      listenable: schedulingListViewModel,
      builder: (context, _) {
        if (schedulingListViewModel.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(schedulingListViewModel.errorMessage!),
            ),
          );
        }

        if (schedulingListViewModel.schedulesLoading) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 28),
              child: Center(child: CustomLoading()),
            ),
          );
        }

        if (schedulingListViewModel.schedules.isEmpty) {
          return const SliverToBoxAdapter(child: CustomEmptyList(label: 'Nenhum agendamento'));
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverList.builder(
            itemCount: schedulingListViewModel.schedules.length + 1,
            itemBuilder: (context, index) {
              if (index == schedulingListViewModel.schedules.length) {
                return const SizedBox(height: 150);
              }

              return CustomSchedulingCard(
                scheduling: schedulingListViewModel.schedules[index],
                index: index,
                onPressed: _editScheduling,
              );
            },
          ),
        );
      },
    );
  }

  void _editScheduling(int index) async {
    if (widget.isReadOnly) {
      return;
    }

    final bool hasChange = await Navigator.pushNamed(
      context,
      '/schedulingDetails',
      arguments: {'scheduling': schedulingListViewModel.schedules[index]},
    ) as bool;

    if (hasChange) {
      schedulingListViewModel.load(dateTime: widget.date);
      if (widget.onSchedulingChanged != null) {
        widget.onSchedulingChanged!();
      }
    }
  }
}
