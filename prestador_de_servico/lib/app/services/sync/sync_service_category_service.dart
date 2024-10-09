import 'package:prestador_de_servico/app/services/sync/sync_service_category_service_impl.dart';

abstract class SyncServiceCategoryService {

  factory SyncServiceCategoryService.create() {
    return SyncServiceCategoryServiceImpl();
  }
  
  Future<void> sync();
}