import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/sync/sync_controller.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/sync/sync_state.dart';

import '../../../helpers/constants/service_category_constants.dart';
import '../../../helpers/network/mock_network_service.dart';
import '../../../helpers/service_category/mock_service_category_repository.dart';
import '../../../helpers/sync/mock_sync_repository.dart';

void main() {
  late SyncServiceCategoryService syncServiceCategoryService;

  setUp(
    () {
      setUpMockSyncRepository();
      setUpMockServiceCategoryRepository();
      setUpNetworkService();
      syncServiceCategoryService = SyncServiceCategoryService(
        syncRepository: mockSyncRepository,
        offlineRepository: onlineMockServiceCategoryRepository,
        onlineRepository: offlineMockServiceCategoryRepository,
      );
    },
  );

  test(
    '''Imediatamento após o início do SyncController o estado do controller 
    deve ser um Syncing''',
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
    '''Ao iniciar o SyncController e um erro ocorrer em _syncData, o estado do controller 
    deve ser um SyncError''',
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
    '''Ao iniciar o SyncController  ee o dispositivo estiver disconectado da internet, 
    o estado do controller deve ser um NoNetworkToSync''',
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
    '''Ao iniciar o SyncController e nenhuma falha ocorrer em _syncData, o estado do do controller 
    deve ser um Synchronized''',
    () async {
      when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
      when(offlineMockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serCatGetAllHasDate));
      when(offlineMockServiceCategoryRepository.existsById(id: anyNamed('id'))).thenAnswer((_) async => Either.right(true));
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
}
