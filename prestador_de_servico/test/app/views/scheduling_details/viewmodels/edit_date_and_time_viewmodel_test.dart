import 'package:flutter_test/flutter_test.dart';
import 'package:prestador_de_servico/app/services/scheduling/scheduling_service.dart';
import 'package:prestador_de_servico/app/views/scheduling_details/viewmodels/edit_date_and_time_viewmodel.dart';

import '../../../../helpers/service_schedulingk/mock_scheduling_repository.dart';

void main() {
  late EditDateAndTimeViewModel editDateAndTimeViewmodel;

  setUp(
    () {
      setUpMockServiceSchedulingRepository();
      editDateAndTimeViewmodel = EditDateAndTimeViewModel(
        schedulingService:
            SchedulingService(onlineRepository: onlineMockSchedulingRepository),
      );
    },
  );
}
