
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

import '../constants/service_category_constants.dart';
import 'mock_service_category_repository.mocks.dart';

@GenerateNiceMocks([MockSpec<ServiceCategoryRepository>()])
late MockServiceCategoryRepository mockServiceCategoryRepository;

void setUpMockServiceCategoryRepository() {
  mockServiceCategoryRepository = MockServiceCategoryRepository();

  when(mockServiceCategoryRepository.getAll()).thenAnswer(
    (_) async => Either.right(serCatGetAll)
  );

  when(mockServiceCategoryRepository.getById(id: serCatNoNetworkConnection.id)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(mockServiceCategoryRepository.getById(id: serCatGetById.id)).thenAnswer(
    (_) async => Either.right(serCatGetById)
  );

  when(mockServiceCategoryRepository.getNameContained(name: serCatNoNetworkConnection.name)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(mockServiceCategoryRepository.getNameContained(name: serCatNameContainedWithoutResult)).thenAnswer(
    (_) async => Either.right(serCatGetNameContainedWithoutResult)
  );

  when(mockServiceCategoryRepository.getNameContained(name: serCatNameContained1Result)).thenAnswer(
    (_) async => Either.right(serCatGetNameContained1Result)
  );

  when(mockServiceCategoryRepository.getNameContained(name: serCatNameContained2Result)).thenAnswer(
    (_) async => Either.right(serCatGetNameContained2Result)
  );

  when(mockServiceCategoryRepository.getNameContained(name: serCatNameContained3Result)).thenAnswer(
    (_) async => Either.right(serCatGetNameContained3Result)
  );

  when(mockServiceCategoryRepository.getUnsync(dateLastSync: anyNamed('dateLastSync'))).thenAnswer(
    (_) async => Either.right(serCatGetUnsync)
  );

  when(mockServiceCategoryRepository.insert(serviceCategory: serCatNoNetworkConnection)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(mockServiceCategoryRepository.insert(serviceCategory: serCatInsert)).thenAnswer(
    (_) async => Either.right(serCatInsert.id)
  );

  when(mockServiceCategoryRepository.update(serviceCategory: serCatNoNetworkConnection)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(mockServiceCategoryRepository.update(serviceCategory: serCatUpdate)).thenAnswer(
    (_) async => Either.right(unit)
  );

  when(mockServiceCategoryRepository.deleteById(id: serCatNoNetworkConnection.id)).thenAnswer(
    (_) async => Either.left(NetworkFailure('Sem conexão com a internet'))
  );

  when(mockServiceCategoryRepository.deleteById(id: serCatDelete.id)).thenAnswer(
    (_) async => Either.right(unit)
  );
}
