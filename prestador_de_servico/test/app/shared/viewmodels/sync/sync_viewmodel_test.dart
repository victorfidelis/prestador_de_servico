import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/services/network/network_service.dart';
import 'package:prestador_de_servico/app/shared/viewmodels/sync/sync_viewmodel.dart';
import 'package:prestador_de_servico/app/services/sync/sync_payment_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_day_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';
import 'package:prestador_de_servico/app/shared/states/sync/sync_state.dart';

class MockSyncRepository extends Mock implements SyncRepository {}

class MockServiceCategoryRepository extends Mock implements ServiceCategoryRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

class MockPaymentRepository extends Mock implements PaymentRepository {}

class MockServiceDayRepository extends Mock implements ServiceDayRepository {}

class MockNetworkService extends Mock implements NetworkService {}

void main() {
  final mockSyncRepository = MockSyncRepository();
  final offlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final onlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final offlineMockServiceRepository = MockServiceRepository();
  final onlineMockServiceRepository = MockServiceRepository();
  final offlineMockPaymentRepository = MockPaymentRepository();
  final onlineMockPaymentRepository = MockPaymentRepository();
  final offlineMockServiceDayRepository = MockServiceDayRepository();
  final onlineMockServiceDayRepository = MockServiceDayRepository();
  final mockNetworkService = MockNetworkService();

  final syncServiceCategoryService = SyncServiceCategoryService(
    syncRepository: mockSyncRepository,
    offlineRepository: offlineMockServiceCategoryRepository,
    onlineRepository: onlineMockServiceCategoryRepository,
  );
  final syncServiceService = SyncServiceService(
    syncRepository: mockSyncRepository,
    offlineRepository: offlineMockServiceRepository,
    onlineRepository: onlineMockServiceRepository,
  );
  final syncPaymentService = SyncPaymentService(
    syncRepository: mockSyncRepository,
    offlineRepository: offlineMockPaymentRepository,
    onlineRepository: onlineMockPaymentRepository,
  );
  final syncServiceDayService = SyncServiceDayService(
    syncRepository: mockSyncRepository,
    offlineRepository: offlineMockServiceDayRepository,
    onlineRepository: onlineMockServiceDayRepository,
  );

  final syncViewModel = SyncViewModel(
    networkService: mockNetworkService,
    syncServiceCategoryService: syncServiceCategoryService,
    syncServiceService: syncServiceService,
    syncPaymentService: syncPaymentService,
    syncServiceDayService: syncServiceDayService,
  );

  group(
    'syncData',
    () {
      test(
        '''Deve alterar o estado para Syncing''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(() => mockSyncRepository.get())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(() => mockNetworkService.isConnectedToInternet()).thenAnswer((_) async => true);

          syncViewModel.syncData();

          expect(syncViewModel.state is Syncing, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para SyncError quando um erro ocorrer no Service/Repository''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(() => mockSyncRepository.get())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(() => mockNetworkService.isConnectedToInternet()).thenAnswer((_) async => true);

          syncViewModel.syncData();

          await Future.delayed(const Duration(seconds: 2));

          expect(syncViewModel.state is SyncError, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para NoNetworkToSync quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(() => mockSyncRepository.get())
              .thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(() => mockNetworkService.isConnectedToInternet()).thenAnswer((_) async => false);

          syncViewModel.syncData();

          await Future.delayed(const Duration(seconds: 2));

          expect(syncViewModel.state is NoNetworkToSync, isTrue);
        },
      );
    },
  );
}
