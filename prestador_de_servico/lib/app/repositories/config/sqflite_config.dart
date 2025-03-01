
import 'package:sqflite/sqflite.dart';

class SqfliteConfig {
  final String nameDb = 'serviceProvider.db';
  final String syncControl = 'syncControl';
  final String serviceCategories = 'serviceCategories';
  final String services = 'services';
  final String payments = 'payments';
  final String serviceDays = 'serviceDays';
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
      version: 3,
      onCreate: (database, version) => createDatabase(database),
    );

    return mainDatabase!;
  }

  void disposeDatabase() {
    if (mainDatabase != null) {
      mainDatabase!.close();
      mainDatabase = null;
    } 
  }

  Future<void> createDatabase(Database database) async {
    await _createSyncControl(database: database);
    await _createServiceCategories(database: database);
    await _createServices(database: database);
    await _createPayments(database: database);
    await _createServiceDay(database: database);
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
        'dateSyncServiceCategory INT, '
        'dateSyncService INT,'
        'dateSyncPayment INT,'
        'dateSyncServiceDay INT'
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
        [services],
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

  Future<void> _createPayments({required Database database}) async {
    int? paymentQuantity = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [payments],
      ),
    );
    if (paymentQuantity == 0) {
      await database.execute(
        'CREATE TABLE $payments ('
        'id TEXT, '
        'paymentType INT, '
        'name TEXT, '
        'urlIcon TEXT, '
        'isActive INT, '
        'nameWithoutDiacritic TEXT'
        ')',
      );
    }
  }

  Future<void> _createServiceDay({required Database database}) async {
    int? serviceDayQuantity = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [serviceDays],
      ),
    );
    if (serviceDayQuantity == 0) {
      await database.execute(
        'CREATE TABLE $serviceDays ('
        'id TEXT, '
        'name TEXT, '
        'dayOfWeek INT, '
        'isActive INT, '
        'openingHour INT, '
        'openingMinute INT, '
        'closingHour INT, '
        'closingMinute INT, '
        'nameWithoutDiacritic TEXT'
        ')',
      );
    }
  }
}
