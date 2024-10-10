import 'package:prestador_de_servico/app/config/sqflite_config.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_adapter.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';
import 'package:replace_diacritic/replace_diacritic.dart';
import 'package:sqflite/sqflite.dart';

  class SqfliteServiceCategoryRepository implements ServiceCategoryRepository {
    Database? database;
    String serviceCategoriesTable = '';

    SqfliteServiceCategoryRepository({this.database});

    Future<void> _initDatabase() async {
      SqfliteConfig sqfliteConfig = SqfliteConfig();
      database ??= await sqfliteConfig.getDatabase();
      if (serviceCategoriesTable.isEmpty) {
        serviceCategoriesTable = sqfliteConfig.serviceCategories;
      }
    }
  
  @override
  Future<List<ServiceCategory>> getAll() async {
    await _initDatabase();

    String selectCommand = ""
        "SELECT "
        "ser_cat.id, "
        "ser_cat.name, "
        "ser_cat.nameWithoutDiacritic "
        "FROM "
        "$serviceCategoriesTable ser_cat";

    List<Map> serviceCategoryMap = await database!.rawQuery(selectCommand);

    List<ServiceCategory> serviceCartegories = serviceCategoryMap
        .map(
          (serviceCategory) =>
              ServiceCartegoryAdapter.fromSqflite(map: serviceCategory),
        )
        .toList();

    return serviceCartegories;
  }

  @override
  Future<ServiceCategory> getById({required String id}) async {
    await _initDatabase();

    String selectCommand = ""
        "SELECT "
        "ser_cat.id, "
        "ser_cat.name, "
        "ser_cat.nameWithoutDiacritic "
        "FROM "
        "$serviceCategoriesTable ser_cat "
        "WHERE "
        "ser_cat.id = ?";

    List params = [id];
    List<Map> serviceCategoryMap =
        await database!.rawQuery(selectCommand, params);

    ServiceCategory serviceCartegory =
        ServiceCartegoryAdapter.fromSqflite(map: serviceCategoryMap[0]);

    return serviceCartegory;
  }

  @override
  Future<List<ServiceCategory>> getNameContained(
      {required String name}) async {
    await _initDatabase();
    String nameWithoutDiacritic = replaceDiacritic(name).trim().toUpperCase();

    String selectCommand = ""
        "SELECT "
        "ser_cat.id, "
        "ser_cat.name, "
        "ser_cat.nameWithoutDiacritic "
        "FROM "
        "$serviceCategoriesTable ser_cat "
        "WHERE "
        "trim(upper(ser_cat.nameWithoutDiacritic)) LIKE '%$nameWithoutDiacritic%'";

    List<Map> serviceCategoryMap = await database!.rawQuery(selectCommand);

    List<ServiceCategory> serviceCartegories = serviceCategoryMap
        .map(
          (serviceCategory) =>
              ServiceCartegoryAdapter.fromSqflite(map: serviceCategory),
        )
        .toList();

    return serviceCartegories;
  }
  
  @override
  Future<List<ServiceCategory>> getUnsync({required DateTime dateLastSync}) {
    throw UnimplementedError();
  }

  @override
  Future<String> insert({required ServiceCategory serviceCategory}) async {
    await _initDatabase();

    String insert = ''
        'INSERT INTO $serviceCategoriesTable '
        '(id, name, nameWithoutDiacritic) '
        'VALUES (?, ?, ?)';
    List params = [
      serviceCategory.id,
      serviceCategory.name.trim(),
      serviceCategory.nameWithoutDiacritics.trim(),
    ];
    await database!.rawInsert(insert, params);

    return serviceCategory.id;
  }

  @override
  Future<void> update({required ServiceCategory serviceCategory}) async {
    await _initDatabase();

    String updateText = ''
        'UPDATE $serviceCategoriesTable '
        'SET '
        'name = ?, '
        'nameWithoutDiacritic = ? '
        'WHERE '
        'id = ?';

    List params = [
      serviceCategory.name.trim(),
      serviceCategory.nameWithoutDiacritics.trim(),
      serviceCategory.id,
    ];

    await database!.rawUpdate(updateText, params);
  }

  @override
  Future<void> deleteById({required String id}) async {
    await _initDatabase();

    String deleteTextMold = ''
        'DELETE FROM '
        '$serviceCategoriesTable '
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
        "ser_cat.id "
        "FROM "
        "$serviceCategoriesTable ser_cat "
        "WHERE "
        "ser_cat.id = ?";

    List params = [id];
    List<Map> serviceCategoryMap =
        await database!.rawQuery(selectCommand, params);

    return serviceCategoryMap.isNotEmpty;
  }
}
