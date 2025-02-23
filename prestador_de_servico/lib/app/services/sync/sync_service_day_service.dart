
import 'package:prestador_de_servico/app/models/service_day/service_day.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/service_day/service_day_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/utils/failure/failure.dart';

class SyncServiceDayService {
  final SyncRepository syncRepository;
  final ServiceDayRepository offlineRepository;
  final ServiceDayRepository onlineRepository;
  late Sync sync;

  SyncServiceDayService({
    required this.syncRepository,
    required this.offlineRepository,
    required this.onlineRepository,
  });
  
  List<ServiceDay> serviceDaysToSync = [];

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
    if (sync.existsSyncDateServiceDays) {
      getEither = await onlineRepository.getUnsync(dateLastSync: sync.dateSyncServiceDay!);
    } else {
      getEither = await onlineRepository.getAll();
    }
    if (getEither.isLeft) {
      return Either.left(getEither.left);
    }

    serviceDaysToSync = getEither.right!;

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> syncUnsynced() async {
    for (ServiceDay serviceDay in serviceDaysToSync) {
      final syncEither = await syncServiceDay(serviceDay);
      if (syncEither.isLeft) {
        return Either.left(syncEither.left);
      }
    } 
    return Either.right(unit);
  } 

  Future<Either<Failure, Unit>> syncServiceDay(ServiceDay serviceDay) async {
    if (serviceDay.isDeleted) {
      return await offlineRepository.deleteById(id: serviceDay.id);
    } 
    
    final existsEither = await offlineRepository.existsById(id: serviceDay.id);
    if (existsEither.isLeft) {
      return Either.left(existsEither.left); 
    }

    if (existsEither.right!) {
      return await offlineRepository.update(serviceDay: serviceDay);
    } else {
      final insertEither = await offlineRepository.insert(serviceDay: serviceDay);
      if (insertEither.isLeft) {
        return Either.left(insertEither.left);
      }
      return Either.right(unit);
    }
  }

  Future<Either<Failure, Unit>> updateSyncDate() async {
    if (serviceDaysToSync.isEmpty) {
      return Either.right(unit);
    }

    DateTime syncDate = getMaxSyncDate();
    final existsEither = await syncRepository.exists(); 
    if (existsEither.isLeft) {
      return Either.left(existsEither.left);
    }

    if (existsEither.right!) {
      return await syncRepository.updateServiceDay(syncDate: syncDate);
    } else {
      sync = sync.copyWith(dateSyncServiceDay: syncDate);
      return await syncRepository.insert(sync: sync);
    }
  }

  DateTime getMaxSyncDate() {
    ServiceDay serviceDay = serviceDaysToSync.reduce(
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
    return serviceDay.syncDate!;
  }
}