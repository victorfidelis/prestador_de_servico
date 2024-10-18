

import 'package:prestador_de_servico/app/models/sync/sync.dart';

final emptySync = Sync();

final syncServiceCategoryData = Sync(dateSyncServiceCategories: DateTime(2024, 10, 10));

final syncServiceData = Sync(dateSyncServices: DateTime(2024, 10, 11));

final syncBothData = Sync(
  dateSyncServiceCategories: DateTime(2024, 10, 15),
  dateSyncServices: DateTime(2024, 10, 16),
);

