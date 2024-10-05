import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service.dart';

class SyncServiceImpl implements SyncService {
  final ServiceCategoryRepository _offlineServiceCategoryRepository =
      ServiceCategoryRepository.create_offline();
  final ServiceCategoryRepository _onlineServiceCategoryRepository =
      ServiceCategoryRepository.create_online();
  final SyncRepository _syncRepository = SyncRepository.create();

  @override
  Future<void> SyncServiceCategory() async {
    Sync sync = await _syncRepository.get();
    List<ServiceCategory> unsyncServiceCategories;
    if (sync.dateSyncServiceCategories == null) {
      unsyncServiceCategories = await _onlineServiceCategoryRepository.getAll();
    } else {
      unsyncServiceCategories =
          await _onlineServiceCategoryRepository.getUnsync(
        dateLastSync: sync.dateSyncServiceCategories!,
      );
    }

    
  }

  Future<void> SyncLocalServiceCategory({required List<ServiceCategory> serviceCategories}) {
    for (ServiceCategory serviceCategory in serviceCategories) {
      
    }
  }

}
