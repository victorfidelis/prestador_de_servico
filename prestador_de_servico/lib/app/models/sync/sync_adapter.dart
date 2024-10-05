import 'package:prestador_de_servico/app/models/sync/sync.dart';

class SyncAdapter {
  static Sync fromSqflite({required Map map}) {
    DateTime? dateSyncServiceCategories;
    if (map['dateSyncServiceCategories'] > 0) {
      dateSyncServiceCategories = DateTime.fromMillisecondsSinceEpoch(map['dateSyncServiceCategories']);
    }
    
    DateTime? dateSyncService;
    if (map['dateSyncService'] > 0) {
      dateSyncService = DateTime.fromMillisecondsSinceEpoch(map['dateSyncService']);
    }

    return Sync(
      dateSyncServiceCategories: dateSyncServiceCategories,
      dateSyncService: dateSyncService,
    );
  }
  
  static Map toSqflite({required Sync sync}) {
    int dateSyncServiceCategories = 0;
    if (sync.dateSyncServiceCategories != null) {
      dateSyncServiceCategories = sync.dateSyncServiceCategories!.millisecondsSinceEpoch;
    }
    
    int dateSyncService = 0;
    if (sync.dateSyncService != null) {
      dateSyncService = sync.dateSyncService!.millisecondsSinceEpoch;
    }

    return {
      'dateSyncServiceCategories': dateSyncServiceCategories,
      'dateSyncService': dateSyncService,
    };
  }
}
