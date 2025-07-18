import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/models/service_status/service_status.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/shared/utils/colors/colors_utils.dart';

class SchedulingDetailsHeader extends StatelessWidget {
  final User user;
  final ServiceStatus serviceStatus;

  const SchedulingDetailsHeader({super.key, required this.user, required this.serviceStatus});

  @override
  Widget build(BuildContext context) {
    Color statusColor = ColorsUtils.getColorFromStatus(
      context,
      serviceStatus,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.fullname,
            style: TextStyle(
              color: statusColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            serviceStatus.name,
            style: TextStyle(
              color: statusColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
