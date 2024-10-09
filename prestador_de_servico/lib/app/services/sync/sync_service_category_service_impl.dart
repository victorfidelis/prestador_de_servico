import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';

class SyncServiceCategoryServiceImpl implements SyncServiceCategoryService {
  final ServiceCategoryRepository _offlineServiceCategoryRepository =
      ServiceCategoryRepository.createOffline();
  final ServiceCategoryRepository _onlineServiceCategoryRepository =
      ServiceCategoryRepository.createOnline();
  final SyncRepository _syncRepository = SyncRepository.create();

  List<ServiceCategory> serviceCategoriesToSync = [];

  @override
  Future<void> sync() async {
    await loadUnsynced();
    await syncUnsynced();
    await updateSyncDate();
  }

  Future<void> loadUnsynced() async {
    Sync sync = await _syncRepository.get();
    if (sync.dateSyncServiceCategories == null) {
      serviceCategoriesToSync = await _onlineServiceCategoryRepository.getAll();
    } else {
      serviceCategoriesToSync =
          await _onlineServiceCategoryRepository.getUnsync(
        dateLastSync: sync.dateSyncServiceCategories!,
      );
    }
  }

  Future<void> syncUnsynced() async {
    for (ServiceCategory serviceCategory in serviceCategoriesToSync) {
      if (serviceCategory.isDeleted) {
        await _offlineServiceCategoryRepository.deleteById(
            id: serviceCategory.id);
      } else if (await _offlineServiceCategoryRepository.existsById(
          id: serviceCategory.id)) {
        await _offlineServiceCategoryRepository.update(
            serviceCategory: serviceCategory);
      } else {
        await _offlineServiceCategoryRepository.insert(
            serviceCategory: serviceCategory);
      }
    }
  }

  Future<void> updateSyncDate() async {
    if (serviceCategoriesToSync.isEmpty) {
      return;
    }

    DateTime syncDate = getMaxSyncDate();
    await _syncRepository.updateServiceCategory(syncDate: syncDate);
  }

  DateTime getMaxSyncDate() {
    ServiceCategory serviceCategory = serviceCategoriesToSync.reduce(
      (value, element) {
        // Todo objeto vindo da nuvem necessariamente deve ter o syncDate
        // Por esse motivo o operador "!" em "syncDate"
        if (value.syncDate!.compareTo(element.syncDate!) > 1) {
          return value;
        } else {
          return element;
        }
      },
    ); 
    return serviceCategory.syncDate!;
  }
}
