import 'package:prestador_de_servico/app/services/sync/sync_service_category_service_impl.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

abstract class SyncServiceCategoryService {

  factory SyncServiceCategoryService.create() {
    return SyncServiceCategoryServiceImpl();
  }
  
  Future<Either<Failure, Unit>> synchronize();
}