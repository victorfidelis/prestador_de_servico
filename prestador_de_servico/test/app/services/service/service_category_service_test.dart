import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/services/service/service_category_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class MockServiceCategoryRepository extends Mock implements ServiceCategoryRepository {}

void main() {
  final offlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final onlineMockServiceCategoryRepository = MockServiceCategoryRepository();
  final serviceCategoryService = ServiceCategoryService(
      offlineRepository: offlineMockServiceCategoryRepository,
      onlineRepository: onlineMockServiceCategoryRepository);
  final ServiceCategory serviceCategory = ServiceCategory(id: '1', name: 'Cabelo');

  group(
    'insert',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => onlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final serviceCategoryEither =
              await serviceCategoryService.insert(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isLeft, isTrue);
          expect(serviceCategoryEither.left is NetworkFailure, isTrue);
          final state = (serviceCategoryEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando uma falha ocorrer no banco offline''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => onlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.right(serviceCategory.id));
          when(() => offlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final serviceCategoryEither =
              await serviceCategoryService.insert(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isLeft, isTrue);
          expect(serviceCategoryEither.left is GetDatabaseFailure, isTrue);
          final state = (serviceCategoryEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um ServiceCategory quando o ServiceCategory for gravado com sucesso''',
        () async {
          when(() => onlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.right(serviceCategory.id));
          when(() => offlineMockServiceCategoryRepository.insert(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.right(serviceCategory.id));

          final serviceCategoryEither =
              await serviceCategoryService.insert(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isRight, isTrue);
          expect(serviceCategoryEither.right, equals(serviceCategory));
        },
      );
    },
  );

  group(
    'update',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => onlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final serviceCategoryEither =
              await serviceCategoryService.update(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isLeft, isTrue);
          expect(serviceCategoryEither.left is NetworkFailure, isTrue);
          final state = (serviceCategoryEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando uma falha ocorrer no banco offline''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => onlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final serviceCategoryEither =
              await serviceCategoryService.update(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isLeft, isTrue);
          expect(serviceCategoryEither.left is GetDatabaseFailure, isTrue);
          final state = (serviceCategoryEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando o ServiceCategory for gravado com sucesso''',
        () async {
          when(() => onlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceCategoryRepository.update(serviceCategory: serviceCategory))
              .thenAnswer((_) async => Either.right(unit));

          final serviceCategoryEither =
              await serviceCategoryService.update(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isRight, isTrue);
          expect(serviceCategoryEither.right is Unit, isTrue);
        },
      );
    },
  );

  group(
    'delete',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => onlineMockServiceCategoryRepository.deleteById(id: serviceCategory.id))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final serviceCategoryEither =
              await serviceCategoryService.delete(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isLeft, isTrue);
          expect(serviceCategoryEither.left is NetworkFailure, isTrue);
          final state = (serviceCategoryEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando uma falha ocorrer no banco offline''',
        () async {
          const failureMessage = 'Teste de falha';
          when(() => onlineMockServiceCategoryRepository.deleteById(id: serviceCategory.id))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceCategoryRepository.deleteById(id: serviceCategory.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final serviceCategoryEither =
              await serviceCategoryService.delete(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isLeft, isTrue);
          expect(serviceCategoryEither.left is GetDatabaseFailure, isTrue);
          final state = (serviceCategoryEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando o ServiceCategory for gravado com sucesso''',
        () async {
          when(() => onlineMockServiceCategoryRepository.deleteById(id: serviceCategory.id))
              .thenAnswer((_) async => Either.right(unit));
          when(() => offlineMockServiceCategoryRepository.deleteById(id: serviceCategory.id))
              .thenAnswer((_) async => Either.right(unit));

          final serviceCategoryEither =
              await serviceCategoryService.delete(serviceCategory: serviceCategory);

          expect(serviceCategoryEither.isRight, isTrue);
          expect(serviceCategoryEither.right is Unit, isTrue);
        },
      );
    },
  );
}
