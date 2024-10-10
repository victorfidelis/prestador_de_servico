import 'package:sqflite/sqflite.dart';

class SqfliteConfig {
  final String nameDb = 'serviceProvider.db';
  final String syncControl = 'syncControl';
  final String serviceCategories = 'serviceCategories';
  final String services = 'services';
  Database? mainDatabase;


  static final SqfliteConfig _instance = SqfliteConfig._internal();
  SqfliteConfig._internal();
  factory SqfliteConfig() {
    return _instance;
  }

  Future<Database> getDatabase() async {
    if (mainDatabase != null) return mainDatabase!;

    final String dataBasePath = await getDatabasesPath();
    final String fullNameDb = '$dataBasePath$nameDb';

    mainDatabase = await openDatabase(
      fullNameDb,
      onOpen: setupDatabase,
    );

    return mainDatabase!;
  }

  void disposeDatabase() {
    if (mainDatabase != null) {
      mainDatabase!.close();
      mainDatabase = null;
    } 
  }

  Future<void> setupDatabase(Database database) async {
    await _createSyncControl(database: database);
    await _createServiceCategories(database: database);
    await _createServices(database: database);
  }

  Future<void> _createSyncControl({required Database database}) async {
    int? integrationControlQuantity = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [syncControl],
      ),
    );
    if (integrationControlQuantity == 0) {
      await database.execute(
        'CREATE TABLE $syncControl ('
        'dateSyncServiceCategories int, '
        'dateSyncService int'
        ')',
      );
    }
  }

  Future<void> _createServiceCategories({required Database database}) async {
    int? serviceCartegoryQuantity = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [serviceCategories],
      ),
    );
    if (serviceCartegoryQuantity == 0) {
      await database.execute(
        'CREATE TABLE $serviceCategories ('
        'id TEXT, '
        'name TEXT, '
        'nameWithoutDiacritic TEXT'
        ')',
      );
    }
  }

  Future<void> _createServices({required Database database}) async {
    int? serviceQuantity = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [serviceCategories],
      ),
    );
    if (serviceQuantity == 0) {
      await database.execute(
        'CREATE TABLE $services ('
        'id TEXT, '
        'serviceCategoryId TEXT, '
        'name TEXT, '
        'price REAL, '
        'hours INT, '
        'minutes INT, '
        'urlImage TEXT, '
        'nameWithoutDiacritic TEXT'
        ')',
      );
    }
  }
}
