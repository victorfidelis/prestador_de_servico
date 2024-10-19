import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';

final serCatGeneric = ServiceCategory(id: '2', name: 'Massagem');
final List<ServiceCategory> serCatsGeneric = [
  ServiceCategory(id: '1', name: 'Cabelo'),
  ServiceCategory(id: '2', name: 'Manicure'),
  ServiceCategory(id: '3', name: 'Pedicure'),
  ServiceCategory(id: '4', name: 'Luzes'),
];

final serCatNoNetworkConnection = ServiceCategory(id: '1', name: 'serCatNoNetworkConnection');

final List<ServiceCategory> serCatGetAll = [
  ServiceCategory(id: '3', name: 'Cabelo'),
  ServiceCategory(id: '4', name: 'Manicure'),
  ServiceCategory(id: '5', name: 'Pedicure'),
  ServiceCategory(id: '6', name: 'Luzes'),
];

final serCatGetById = ServiceCategory(id: '2', name: 'serCatGetById');

const serCatNameContainedWithoutResult = 'sem resultado';
final List<ServiceCategory> serCatGetNameContainedWithoutResult = [];

const serCatNameContained1Result = 'cab';
final List<ServiceCategory> serCatGetNameContained1Result = [
  ServiceCategory(id: '3', name: 'Cabelo'),
];

const serCatNameContained2Result = 'cure';
final List<ServiceCategory> serCatGetNameContained2Result = [
  ServiceCategory(id: '4', name: 'Manicure'),
  ServiceCategory(id: '5', name: 'Pedicure'),
];

const serCatNameContained3Result = 'a';
final List<ServiceCategory> serCatGetNameContained3Result = [
  ServiceCategory(id: '3', name: 'Cabelo'),
  ServiceCategory(id: '4', name: 'Manicure'),
  ServiceCategory(id: '5', name: 'Pedicure'),
];

final List<ServiceCategory> serCatGetUnsync = [
  ServiceCategory(id: '4', name: 'Manicure'),
  ServiceCategory(id: '5', name: 'Pedicure'),
  ServiceCategory(id: '6', name: 'Luzes'),
];

final serCatInsert = ServiceCategory(id: '7', name: 'Insert');

final serCatUpdate = ServiceCategory(id: '8', name: 'Update');

final serCatDelete = ServiceCategory(id: '9', name: 'Delete');

final serCatInsertWithoutName = ServiceCategory(id: '', name: '');

final serCatUpdateWithoutName = ServiceCategory(id: '1', name: '');

final serCatIsDeleted = ServiceCategory(id: '1', name: 'isDeleted', isDeleted: true);

final serCatSync20241015 = ServiceCategory(id: '1', name: 'serviceCategory1', syncDate: DateTime(2024, 10, 15));

final serCatSync20241016 = ServiceCategory(id: '2', name: 'serviceCategory2', syncDate: DateTime(2024, 10, 16));

final serCatSync20241017 = ServiceCategory(id: '3', name: 'serviceCategory3', syncDate: DateTime(2024, 10, 17));

final serCatGetAllHasDate = [
  serCatSync20241015,
  serCatSync20241016,
  serCatSync20241017,
];