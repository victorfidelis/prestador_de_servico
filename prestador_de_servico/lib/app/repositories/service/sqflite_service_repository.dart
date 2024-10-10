import 'package:prestador_de_servico/app/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service/service_adapter.dart';
import 'package:prestador_de_servico/app/repositories/service/service_repository.dart';
import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteServiceRepository implements ServiceRepository {
  Database? database;
  String servicesTable = '';

  SqfliteServiceRepository({this.database});

  Future<void> _initDatabase() async {
    SqfliteConfig sqfliteConfig = SqfliteConfig();
    database ??= await sqfliteConfig.getDatabase();
    if (servicesTable.isEmpty) {
      servicesTable = sqfliteConfig.services;
    }
  }

  @override
  Future<List<Service>> getAll() async {
    await _initDatabase();

    String selectCommand = ""
        "SELECT "
        "ser.id, "
        "ser.serviceCategoryId, "
        "ser.name, "
        "ser.price, "
        "ser.hours, "
        "ser.minutes, "
        "ser.urlImage, "
        "ser.nameWithoutDiacritic "
        "FROM "
        "$servicesTable ser";

    List<Map> servicesMap = await database!.rawQuery(selectCommand);

    List<Service> services = servicesMap
        .map((service) => ServiceAdapter.fromSqflite(map: service))
        .toList();

    return services;
  }

  @override
  Future<List<Service>> getByServiceCategoryId(
      {required String serviceCategoryId}) async {
    await _initDatabase();

    String selectCommand = ""
        "SELECT "
        "ser.id, "
        "ser.serviceCategoryId, "
        "ser.name, "
        "ser.price, "
        "ser.hours, "
        "ser.minutes, "
        "ser.urlImage, "
        "ser.nameWithoutDiacritic "
        "FROM "
        "$servicesTable ser "
        "WHERE ser.serviceCategoryId = ?";

    List params = [serviceCategoryId];
    List<Map> servicesMap = await database!.rawQuery(selectCommand, params);

    List<Service> services = servicesMap
        .map((service) => ServiceAdapter.fromSqflite(map: service))
        .toList();

    return services;
  }

  @override
  Future<Service> getById({required String id}) async {
    await _initDatabase();

    String selectCommand = ""
        "SELECT "
        "ser.id, "
        "ser.serviceCategoryId, "
        "ser.name, "
        "ser.price, "
        "ser.hours, "
        "ser.minutes, "
        "ser.urlImage, "
        "ser.nameWithoutDiacritic "
        "FROM "
        "$servicesTable ser "
        "WHERE ser.id = ?";

    List params = [id];
    List<Map> serviceMap = await database!.rawQuery(selectCommand, params);

    Service service = ServiceAdapter.fromSqflite(map: serviceMap[0]);

    return service;
  }

  @override
  Future<List<Service>> getNameContained({required String name}) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name).trim().toUpperCase();

    String selectCommand = ""
        "SELECT "
        "ser.id, "
        "ser.serviceCategoryId, "
        "ser.name, "
        "ser.price, "
        "ser.hours, "
        "ser.minutes, "
        "ser.urlImage, "
        "ser.nameWithoutDiacritic "
        "FROM "
        "$servicesTable ser "
        "WHERE "
        "trim(upper(ser.nameWithoutDiacritic)) LIKE '%$nameWithoutDiacritic%'";

    List<Map> serviceMap = await database!.rawQuery(selectCommand);

    List<Service> services = serviceMap
        .map((service) => ServiceAdapter.fromSqflite(map: service))
        .toList();

    return services;
  }

  @override
  Future<List<Service>> getUnsync({required DateTime dateLastSync}) {
    throw UnimplementedError();
  }

  @override
  Future<String> insert({required Service service}) async {
    await _initDatabase();

    String insert = ""
        "INSERT INTO $servicesTable "
        "("
        "id, "
        "serviceCategoryId, "
        "name, "
        "price, "
        "hours, "
        "minutes, "
        "urlImage, "
        "nameWithoutDiacritic"
        ") "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    List params = [
      service.id,
      service.serviceCategoryId,
      service.name.trim(),
      service.price,
      service.hours,
      service.minutes,
      service.urlImage.trim(),
      service.nameWithoutDiacritics.trim(),
    ];

    await database!.rawInsert(insert, params);

    return service.id;
  }

  @override
  Future<void> update({required Service service}) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $servicesTable '
        'SET '
        'serviceCategoryId = ?, '
        'name = ?, '
        'price = ?, '
        'hours = ?, '
        'minutes = ?, '
        'urlImage = ?, '
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';

    List params = [
      service.serviceCategoryId.trim(),
      service.name.trim(),
      service.price,
      service.hours,
      service.minutes,
      service.urlImage.trim(),
      service.nameWithoutDiacritics.trim(),
      service.id,
    ];

    await database!.rawUpdate(updateText, params);
  }

  @override
  Future<void> deleteById({required String id}) async {
    await _initDatabase();

    String deleteTextMold = ''
        'DELETE FROM '
        '$servicesTable '
        'WHERE '
        'id = ?';

    List params = [id];

    await database!.rawDelete(deleteTextMold, params);
  }

  @override
  Future<bool> existsById({required String id}) async {
    await _initDatabase();

    String selectCommand = ""
        "SELECT "
        "ser.id "
        "FROM "
        "$servicesTable ser "
        "WHERE "
        "ser.id = ?";

    List params = [id];
    List<Map> serviceMap =
        await database!.rawQuery(selectCommand, params);

    return serviceMap.isNotEmpty;
  }
}
