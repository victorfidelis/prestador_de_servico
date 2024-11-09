import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/sync/sync_controller.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/sync/sync_state.dart';

import '../../../helpers/network/mock_network_service.dart';
import '../../../helpers/service/service_category/mock_service_category_repository.dart';
import '../../../helpers/sync/mock_sync_repository.dart';

void main() {
  late SyncServiceCategoryService syncServiceCategoryService;

  late ServiceCategory serviceCategory1;
  late ServiceCategory serviceCategory2;
  late ServiceCategory serviceCategory3;
  late List<ServiceCategory> serviceCategories;

  setUpValues() {
    serviceCategory1 = ServiceCategory(id: '1', name: 'serviceCategory1', syncDate: DateTime(2024, 10, 15));
    serviceCategory2 = ServiceCategory(id: '2', name: 'serviceCategory2', syncDate: DateTime(2024, 10, 16));
    serviceCategory3 = ServiceCategory(id: '3', name: 'serviceCategory3', syncDate: DateTime(2024, 10, 17));

    serviceCategories = [
      serviceCategory1,
      serviceCategory2,
      serviceCategory3,
    ];
  }

  setUp(
    () {
      setUpMockSyncRepository();
      setUpMockServiceCategoryRepository();
      setUpNetworkService();
      syncServiceCategoryService = SyncServiceCategoryService(
        syncRepository: mockSyncRepository,
        offlineRepository: offlineMockServiceCategoryRepository,
        onlineRepository: onlineMockServiceCategoryRepository,
      );
      setUpValues();
    },
  );

  group(
    'Construtor',
    () {
      test(
        '''Deve alterar o estado para Syncing''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

          final syncController = SyncController(
            networkService: mockNetworkService,
            syncServiceCategoryService: syncServiceCategoryService,
          );

          expect(syncController.state is Syncing, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para SyncError quando um erro ocorrer no Service/Repository''',
        () async {
          const failureMessage = 'Falha loadSyncInfo';
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure(failureMessage)));
          when(mockNetworkService.isConnectedToInternet()).thenAnswer((_) async => true);

          final syncController = SyncController(
            networkService: mockNetworkService,
            syncServiceCategoryService: syncServiceCategoryService,
          );
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

          final syncController = SyncController(
            networkService: mockNetworkService,
            syncServiceCategoryService: syncServiceCategoryService,
          );
          await Future.delayed(const Duration(seconds: 2));

          expect(syncController.state is NoNetworkToSync, isTrue);
        },
      );

      test(
        '''Deve alterar o estado para Synchronized quando nenhuma falha ocorrer.''',
        () async {
          when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
          when(onlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serviceCategories));
          when(offlineMockServiceCategoryRepository.existsById(id: anyNamed('id')))
              .thenAnswer((_) async => Either.right(true));
          when(offlineMockServiceCategoryRepository.update(serviceCategory: anyNamed('serviceCategory')))
              .thenAnswer((_) async => Either.right(unit));
          when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
          when(mockSyncRepository.updateServiceCategory(syncDate: anyNamed('syncDate')))
              .thenAnswer((_) async => Either.right(unit));
          when(mockNetworkService.isConnectedToInternet()).thenAnswer((_) async => true);

          final syncController = SyncController(
            networkService: mockNetworkService,
            syncServiceCategoryService: syncServiceCategoryService,
          );

          await Future.delayed(const Duration(seconds: 2));

          expect(syncController.state is Synchronized, isTrue);
        },
      );
    },
  );
}
