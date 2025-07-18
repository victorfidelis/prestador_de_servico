import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/service/service/service_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure.dart';

class SyncServiceService {
  final SyncRepository syncRepository;
  final ServiceRepository offlineRepository;
  final ServiceRepository onlineRepository;
  late Sync sync;

  SyncServiceService({
    required this.syncRepository,
    required this.offlineRepository,
    required this.onlineRepository,
  });
  
  List<Service> servicesToSync = [];

  Future<Either<Failure, Unit>> synchronize() async {
    final loadInfoSyncEither = await loadSyncInfo();
    if (loadInfoSyncEither.isLeft) {
      return Either.left(loadInfoSyncEither.left);
    }

    final loadUnsyncedEither = await loadUnsynced();
    if (loadUnsyncedEither.isLeft) {
      return Either.left(loadUnsyncedEither.left);
    }

    final syncUnsyncedEither = await syncUnsynced();
    if (syncUnsyncedEither.isLeft) {
      return Either.left(syncUnsyncedEither.left);
    }

    final updateSyncDateEither = await updateSyncDate();
    if (updateSyncDateEither.isLeft) {
      return Either.left(updateSyncDateEither.left);
    } 

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> loadSyncInfo() async {
    final getSyncEither = await syncRepository.get();
    if (getSyncEither.isLeft) {
      return Either.left(getSyncEither.left);
    }
    sync = getSyncEither.right!;
    return Either.right(unit);
  }
  
  Future<Either<Failure, Unit>> loadUnsynced() async {
    Either getEither;
    if (sync.existsSyncDateServices) {
      getEither = await onlineRepository.getUnsync(dateLastSync: sync.dateSyncService!);
    } else {
      getEither = await onlineRepository.getAll();
    }
    if (getEither.isLeft) {
      return Either.left(getEither.left);
    }

    servicesToSync = getEither.right!;

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> syncUnsynced() async {
    for (Service service in servicesToSync) {
      final syncEither = await syncService(service);
      if (syncEither.isLeft) {
        return Either.left(syncEither.left);
      }
    } 
    return Either.right(unit);
  } 

  Future<Either<Failure, Unit>> syncService(Service service) async {
    if (service.isDeleted) {
      return await offlineRepository.deleteById(id: service.id);
    } 
    
    final existsEither = await 
    offlineRepository.existsById(id: service.id);
    if (existsEither.isLeft) {
      return Either.left(existsEither.left); 
    }

    if (existsEither.right!) {
      return await offlineRepository.update(service: service);
    } else {
      final insertEither = await offlineRepository.insert(service: service);
      if (insertEither.isLeft) {
        return Either.left(insertEither.left);
      }
      return Either.right(unit);
    }
  }

  Future<Either<Failure, Unit>> updateSyncDate() async {
    if (servicesToSync.isEmpty) {
      return Either.right(unit);
    }

    DateTime syncDate = getMaxSyncDate();
    final existsEither = await syncRepository.exists(); 
    if (existsEither.isLeft) {
      return Either.left(existsEither.left);
    }

    if (existsEither.right!) {
      return await syncRepository.updateService(syncDate: syncDate);
    } else {
      sync = sync.copyWith(dateSyncServiceCategory: syncDate);
      return await syncRepository.insert(sync: sync);
    }
  }

  DateTime getMaxSyncDate() {
    Service service = servicesToSync.reduce(
      (value, element) {
        // Todo objeto vindo da nuvem necessariamente deve ter o syncDate
        // Por esse motivo o operador "!" em "syncDate"
        if (value.syncDate!.compareTo(element.syncDate!) > 0) {
          return value;
        } else {
          return element;
        }
      },
    );
    return service.syncDate!;
  }
}