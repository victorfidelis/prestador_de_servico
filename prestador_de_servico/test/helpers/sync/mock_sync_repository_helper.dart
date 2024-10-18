
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'mock_sync_repository_helper.mocks.dart';

@GenerateNiceMocks([MockSpec<SyncRepository>()])

late MockSyncRepository mockSyncRepository;

void setUpMockSyncRepository() {
  mockSyncRepository = MockSyncRepository();

  when(mockSyncRepository.get()).thenAnswer((_) async => Either.right(Sync()));

  
}


