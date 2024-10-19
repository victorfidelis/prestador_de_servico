import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/controllers/sync/sync_controller.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';

import '../../../helpers/constants/service_category_constants.dart';
import '../../../helpers/service_category/mock_service_category_repository.dart';
import '../../../helpers/sync/mock_sync_repository_helper.dart';

void main() {
  late SyncServiceCategoryService syncServiceCategoryService;

  setUp(
    () {
      setUpMockSyncRepository();
      setUpMockServiceCategoryRepository();
      syncServiceCategoryService = SyncServiceCategoryService(
        syncRepository: mockSyncRepository,
        offlineRepository: mockServiceCategoryRepository,
        onlineRepository: mockServiceCategoryRepository,
      );
    },
  );
  
  test(
    '''Imediatamento após o início do SyncController o estado do do controller 
    deve ser um Syncing''',
    () async {
      const failureMessage = 'Falha loadSyncInfo';
      when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

      final syncController = SyncController(syncServiceCategoryService: syncServiceCategoryService);
      
      expect(syncController.state is Syncing, isTrue);
    },
  );

  test(
    '''Ao iniciar o SyncController e um ocorrer em _syncData, o estado do do controller 
    deve ser um SyncError''',
    () async {
      const failureMessage = 'Falha loadSyncInfo';
      when(mockSyncRepository.get()).thenAnswer((_) async => Either.left(Failure(failureMessage)));

      final syncController = SyncController(syncServiceCategoryService: syncServiceCategoryService);
      await Future.delayed(const Duration(seconds: 2));

      expect(syncController.state is SyncError, isTrue);
    },
  );

  test(
    '''Ao iniciar o SyncController e nenhuma falha ocorrer em _syncData, o estado do do controller 
    deve ser um Synchronized''',
    () async {
      when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));
      when(mockServiceCategoryRepository.getAll()).thenAnswer((_) async => Either.right(serCatGetAllHasDate));
      when(mockServiceCategoryRepository.existsById(id: anyNamed('id'))).thenAnswer((_) async => Either.right(true));
      when(mockServiceCategoryRepository.update(serviceCategory: anyNamed('serviceCategory')))
          .thenAnswer((_) async => Either.right(unit));
      when(mockSyncRepository.exists()).thenAnswer((_) async => Either.right(true));
      when(mockSyncRepository.updateServiceCategory(syncDate: anyNamed('syncDate')))
          .thenAnswer((_) async => Either.right(unit));

      final syncController = SyncController(syncServiceCategoryService: syncServiceCategoryService);

      await Future.delayed(const Duration(seconds: 2));

      expect(syncController.state is Synchronized, isTrue);
    },
  );
}
