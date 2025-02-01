import 'package:prestador_de_servico/app/models/sync/sync.dart';

class SyncAdapter {
  static Sync fromSqflite({required Map map}) {
    DateTime? dateSyncServiceCategory;
    if (map['dateSyncServiceCategory'] > 0) {
      dateSyncServiceCategory = DateTime.fromMillisecondsSinceEpoch(map['dateSyncServiceCategory']);
    }
    
    DateTime? dateSyncService;
    if (map['dateSyncService'] > 0) {
      dateSyncService = DateTime.fromMillisecondsSinceEpoch(map['dateSyncService']);
    }
    
    DateTime? dateSyncPayment;
    if (map['dateSyncPayment'] > 0) {
      dateSyncPayment = DateTime.fromMillisecondsSinceEpoch(map['dateSyncPayment']);
    }

    return Sync(
      dateSyncServiceCategory: dateSyncServiceCategory,
      dateSyncService: dateSyncService,
      dateSyncPayment: dateSyncPayment,
    );
  }
  
  static Map toSqflite({required Sync sync}) {
    int dateSyncServiceCategory = 0;
    if (sync.dateSyncServiceCategory != null) {
      dateSyncServiceCategory = sync.dateSyncServiceCategory!.millisecondsSinceEpoch;
    }
    
    int dateSyncService = 0;
    if (sync.dateSyncService != null) {
      dateSyncService = sync.dateSyncService!.millisecondsSinceEpoch;
    }
    
    int dateSyncPayment = 0;
    if (sync.dateSyncPayment != null) {
      dateSyncPayment = sync.dateSyncPayment!.millisecondsSinceEpoch;
    }

    return {
      'dateSyncServiceCategory': dateSyncServiceCategory,
      'dateSyncService': dateSyncService,
      'dateSyncPayment': dateSyncPayment,
    };
  }
}
