
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
