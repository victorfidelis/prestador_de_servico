import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/services/service/service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

import '../../../helpers/image/mock_image_repository.dart';
import '../../../helpers/service/service/mock_service_repository.dart';

void main() {
  late ServiceService serviceService;

  late Service service1;
  late Service serviceWithImageFile;
  late Service serviceWithImageUrl;

  setUpValues() {
    service1 = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Luzes',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: '',
    );

    serviceWithImageFile = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Luzes',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: '',
      imageFile: File('caminho imagem'),
    );

    serviceWithImageUrl = Service(
      id: '1',
      serviceCategoryId: '1',
      name: 'Luzes',
      price: 49.90,
      hours: 1,
      minutes: 30,
      imageUrl: 'prestador_de_servico.com/imagem_teste.jpg',
      imageFile: null,
    );
  }

  setUp(
    () {
      setUpMockServiceRepository();
      setUpMockImageRepository();
      serviceService = ServiceService(
        offlineRepository: offlineMockServiceRepository,
        onlineRepository: onlineMockServiceRepository,
        imageRepository: mockImageRepository,
      );
      setUpValues();
    },
  );

  group(
    'insert',
    () {
      test(
        '''Deve retornar um NetworkFailure quando não tiver acesso a internet''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final insertEither = await serviceService.insert(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is NetworkFailure, isTrue);
          final state = (insertEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));
          when(offlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final insertEither = await serviceService.insert(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is GetDatabaseFailure, isTrue);
          final state = (insertEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um UploadImageFailure quando ocorrer uma falha ao enviar imagem para a
        nuvem''',
        () async {
          const failureMessage = 'Falha de teste';

          when(onlineMockServiceRepository.insert(service: serviceWithImageFile))
              .thenAnswer((_) async => Either.right(serviceWithImageFile.id));
          when(offlineMockServiceRepository.insert(service: serviceWithImageFile))
              .thenAnswer((_) async => Either.right(serviceWithImageFile.id));
          when(mockImageRepository.uploadImage(
            imageFile: serviceWithImageFile.imageFile,
            imageFileName: serviceWithImageFile.imageName,
          )).thenAnswer((_) async => Either.left(UploadImageFailure(failureMessage)));

          final insertEither = await serviceService.insert(service: serviceWithImageFile);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is UploadImageFailure, isTrue);
          final state = (insertEither.left as UploadImageFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando a gravação do Service for feita com sucesso''',
        () async {
          when(onlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));
          when(offlineMockServiceRepository.insert(service: service1))
              .thenAnswer((_) async => Either.right(service1.id));

          final insertEither = await serviceService.insert(service: service1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Service, isTrue);
          expect(insertEither.right, equals(service1));
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
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final insertEither = await serviceService.update(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is NetworkFailure, isTrue);
          final state = (insertEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.update(service: service1)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.update(service: service1))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final insertEither = await serviceService.update(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is GetDatabaseFailure, isTrue);
          final state = (insertEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um UploadImageFailure quando ocorrer uma falha ao enviar imagem para a
        nuvem''',
        () async {
          const failureMessage = 'Falha de teste';

          when(mockImageRepository.uploadImage(
            imageFile: serviceWithImageFile.imageFile,
            imageFileName: serviceWithImageFile.imageName,
          )).thenAnswer((_) async => Either.left(UploadImageFailure(failureMessage)));

          final insertEither = await serviceService.update(service: serviceWithImageFile);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is UploadImageFailure, isTrue);
          final state = (insertEither.left as UploadImageFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Service quando a gravação do Service for feita com sucesso''',
        () async {
          when(onlineMockServiceRepository.update(service: service1)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.update(service: service1)).thenAnswer((_) async => Either.right(unit));

          final insertEither = await serviceService.update(service: service1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Service, isTrue);
          expect(insertEither.right, equals(service1));
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
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.left(NetworkFailure(failureMessage)));

          final insertEither = await serviceService.delete(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is NetworkFailure, isTrue);
          final state = (insertEither.left as NetworkFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um GetDatabaseFailure quando ocorrer uma falha no banco offline''',
        () async {
          const failureMessage = 'Falha de teste';
          when(onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: service1.id))
              .thenAnswer((_) async => Either.left(GetDatabaseFailure(failureMessage)));

          final insertEither = await serviceService.delete(service: service1);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is GetDatabaseFailure, isTrue);
          final state = (insertEither.left as GetDatabaseFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um DeleteImageFailure quando um erro ocorrer ao excluir uma imagem''',
        () async {
          const failureMessage = 'Falha de teste';
          when(mockImageRepository.deleteImage(imageUrl: serviceWithImageUrl.imageUrl))
              .thenAnswer((_) async => Either.left(DeleteImageFailure(failureMessage)));

          final insertEither = await serviceService.delete(service: serviceWithImageUrl);

          expect(insertEither.isLeft, isTrue);
          expect(insertEither.left is DeleteImageFailure, isTrue);
          final state = (insertEither.left as DeleteImageFailure);
          expect(state.message, equals(failureMessage));
        },
      );

      test(
        '''Deve retornar um Unit quando ao excluir a imagem ocorra um erro informando que 
        a mesma não existe''',
        () async {
          const failureMessage = 'Falha de teste';
          when(mockImageRepository.deleteImage(imageUrl: serviceWithImageUrl.imageUrl))
              .thenAnswer((_) async => Either.left(ImageNotFoundFailure(failureMessage)));
          when(onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer((_) async => Either.right(unit));

          final insertEither = await serviceService.delete(service: serviceWithImageUrl);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Unit, isTrue);
        },
      );

      test(
        '''Deve retornar um Unit quando a gravação do Service for feita com sucesso''',
        () async {
          when(onlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer((_) async => Either.right(unit));
          when(offlineMockServiceRepository.deleteById(id: service1.id)).thenAnswer((_) async => Either.right(unit));

          final insertEither = await serviceService.delete(service: service1);

          expect(insertEither.isRight, isTrue);
          expect(insertEither.right is Unit, isTrue);
        },
      );
    },
  );
}
