
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../../constants/service_category_constants.dart';
import 'mock_service_category_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<ServiceCategoryRepository>()])
late MockServiceCategoryRepository onlineMockServiceCategoryRepository;
late MockServiceCategoryRepository offlineMockServiceCategoryRepository;

void setUpMockServiceCategoryRepository() {
  onlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  offlineMockServiceCategoryRepository = MockServiceCategoryRepository();


  when(onlineMockServiceCategoryRepository.getAll()).thenAnswer(
    (_) async => Either.right(serCatGetAll)
  );

  when(onlineMockServiceCategoryRepository.getById(id: serCatNoNetworkConnection.id)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(onlineMockServiceCategoryRepository.getById(id: serCatGetById.id)).thenAnswer(
    (_) async => Either.right(serCatGetById)
  );

  when(onlineMockServiceCategoryRepository.getNameContained(name: serCatNoNetworkConnection.name)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(onlineMockServiceCategoryRepository.getNameContained(name: serCatNameContainedWithoutResult)).thenAnswer(
    (_) async => Either.right(serCatGetNameContainedWithoutResult)
  );

  when(onlineMockServiceCategoryRepository.getNameContained(name: serCatNameContained1Result)).thenAnswer(
    (_) async => Either.right(serCatGetNameContained1Result)
  );

  when(onlineMockServiceCategoryRepository.getNameContained(name: serCatNameContained2Result)).thenAnswer(
    (_) async => Either.right(serCatGetNameContained2Result)
  );

  when(onlineMockServiceCategoryRepository.getNameContained(name: serCatNameContained3Result)).thenAnswer(
    (_) async => Either.right(serCatGetNameContained3Result)
  );

  when(onlineMockServiceCategoryRepository.getUnsync(dateLastSync: anyNamed('dateLastSync'))).thenAnswer(
    (_) async => Either.right(serCatGetUnsync)
  );

  when(onlineMockServiceCategoryRepository.insert(serviceCategory: serCatNoNetworkConnection)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(onlineMockServiceCategoryRepository.insert(serviceCategory: serCatInsert)).thenAnswer(
    (_) async => Either.right(serCatInsert.id)
  );

  when(onlineMockServiceCategoryRepository.update(serviceCategory: serCatNoNetworkConnection)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(onlineMockServiceCategoryRepository.update(serviceCategory: serCatUpdate)).thenAnswer(
    (_) async => Either.right(unit)
  );

  when(onlineMockServiceCategoryRepository.deleteById(id: serCatNoNetworkConnection.id)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(onlineMockServiceCategoryRepository.deleteById(id: serCatDelete.id)).thenAnswer(
    (_) async => Either.right(unit)
  );
}
