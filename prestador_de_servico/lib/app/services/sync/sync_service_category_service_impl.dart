import 'package:prestador_de_servico/app/controllers/auth/create_user_controller.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class SyncServiceCategoryServiceImpl implements SyncServiceCategoryService {
  final _offlineServiceCategoryRepository = ServiceCategoryRepository.createOffline();
  final _onlineServiceCategoryRepository = ServiceCategoryRepository.createOnline();
  final _syncRepository = SyncRepository.create();
  late Sync sync;

  List<ServiceCategory> serviceCategoriesToSync = [];

  @override
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

  Future<Either<Failure, dynamic>> loadSyncInfo() async {
    final getSyncEither = await _syncRepository.get();
    if (getSyncEither.isLeft) {
      return Either.left(getSyncEither.left);
    }
    sync = getSyncEither.right!;
    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> loadUnsynced() async {
    Either getEither;
    if (sync.existsSyncDateServiceCategories) {
      getEither = await _onlineServiceCategoryRepository.getAll();
    } else {
      getEither = await _onlineServiceCategoryRepository.getUnsync(dateLastSync: sync.dateSyncServiceCategories!);
    }
    if (getEither.isLeft) {
      return Either.left(getEither.left);
    }

    serviceCategoriesToSync = getEither.right!;

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> syncUnsynced() async {
    for (ServiceCategory serviceCategory in serviceCategoriesToSync) {
      final syncEither = await syncServiceCategory(serviceCategory);
      if (syncEither.isLeft) {
        return Either.left(syncEither.left);
      }
    } 
    return Either.right(unit);
  } 

  Future<Either<Failure, Unit>> syncServiceCategory(ServiceCategory serviceCategory) async {
    if (serviceCategory.isDeleted) {
      return await _offlineServiceCategoryRepository.deleteById(id: serviceCategory.id);
    } 
    
    final existsEither = await _offlineServiceCategoryRepository.existsById(id: serviceCategory.id);
    if (existsEither.isLeft) {
      return Either.left(existsEither.left); 
    }

    if (existsEither.right!) {
      return await _offlineServiceCategoryRepository.update(serviceCategory: serviceCategory);
    } else {
      final insertEither = await _offlineServiceCategoryRepository.insert(serviceCategory: serviceCategory);
      if (insertEither.isLeft) {
        return Either.left(insertEither.left);
      }
      return Either.right(unit);
    }
  }

  Future<Either<Failure, Unit>> updateSyncDate() async {
    if (serviceCategoriesToSync.isEmpty) {
      return Either.right(unit);
    }

    DateTime syncDate = getMaxSyncDate();
    final existsEither = await _syncRepository.exists(); 
    if (existsEither.isLeft) {
      return Either.left(existsEither.left);
    }

    if (existsEither.right!) {
      return await _syncRepository.updateServiceCategory(syncDate: syncDate);
    } else {
      sync = sync.copyWith(dateSyncServiceCategories: syncDate);
      return await _syncRepository.insert(sync: sync);
    }
  }

  DateTime getMaxSyncDate() {
    ServiceCategory serviceCategory = serviceCategoriesToSync.reduce(
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
    return serviceCategory.syncDate!;
  }
}
