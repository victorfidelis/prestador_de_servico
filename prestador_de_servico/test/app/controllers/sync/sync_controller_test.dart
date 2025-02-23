import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/sync/sync_viewmodel.dart';
import 'package:prestador_de_servico/app/services/sync/sync_payment_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_day_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/shared/sync/sync_state.dart';

import '../../../helpers/network/mock_network_service.dart';
import '../../../helpers/payment/mock_payment_repository.dart';
import '../../../helpers/service/service/mock_service_repository.dart';
import '../../../helpers/service/service_category/mock_service_category_repository.dart';
import '../../../helpers/service_day/mock_service_day_repository.dart';
import '../../../helpers/sync/mock_sync_repository.dart';

void main() {
  late SyncController syncController;

  late SyncServiceCategoryService syncServiceCategoryService;
  late SyncServiceService syncServiceService;
  late SyncPaymentService syncPaymentService;
  late SyncServiceDayService syncServiceDayService;

  setUpValues() {
    syncServiceCategoryService = SyncServiceCategoryService(
      syncRepository: mockSyncRepository,
      offlineRepository: offlineMockServiceCategoryRepository,
      onlineRepository: onlineMockServiceCategoryRepository,
    );
    syncServiceService = SyncServiceService(
      syncRepository: mockSyncRepository,
      offlineRepository: offlineMockServiceRepository,
      onlineRepository: onlineMockServiceRepository,
    );
    syncPaymentService = SyncPaymentService(
      syncRepository: mockSyncRepository,
      offlineRepository: offlineMockPaymentRepository,
      onlineRepository: onlineMockPaymentRepository,
    );
    syncServiceDayService = SyncServiceDayService(
      syncRepository: mockSyncRepository,
      offlineRepository: offlineMockServiceDayRepository,
      onlineRepository: onlineMockServiceDayRepository,
    );
    syncController = SyncController(
      networkService: mockNetworkService,
      syncServiceCategoryService: syncServiceCategoryService,
      syncServiceService: syncServiceService,
      syncPaymentService: syncPaymentService, 
      syncServiceDayService: syncServiceDayService,
    );
  }

  setUp(
    () {
      setUpMockSyncRepository();
      setUpMockServiceCategoryRepository();
      setUpMockServiceRepository();
      setUpMockPaymentRepository();
      setUpMockServiceDayRepository();
      setUpNetworkService();
      setUpValues();
    },
  );

  group(
    'syncData',
    () {
      test(
        '''Deve alterar o estado para Syncing''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          syncController.syncData();

          expect(syncController.state is Syncing, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para SyncError quando um erro ocorrer no Service/Repository''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(mockNetworkService.isConnectedToInternet()).thenAnswer((_) async => true);

          syncController.syncData();

          await Future.delayed(const Duration(seconds: 2));

          expect(syncController.state is SyncError, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para NoNetworkToSync quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(mockNetworkService.isConnectedToInternet()).thenAnswer((_) async => false);

          syncController.syncData();

          await Future.delayed(const Duration(seconds: 2));

          expect(syncController.state is NoNetworkToSync, isTrue);
        },
      );
    },
  );
}
