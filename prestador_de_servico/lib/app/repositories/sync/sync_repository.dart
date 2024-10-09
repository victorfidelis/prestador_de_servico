import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/sync/sqflite_sync_repository.dart';

abstract class SyncRepository {

  factory SyncRepository.create() {
    return SqfliteSyncRepository();
  }

  Future<Sync> get(); 
  Future<void> insert({required Sync sync}); 
  Future<void> updateServiceCategory({required DateTime syncDate}); 
  Future<void> updateService({required DateTime syncDate}); 
}