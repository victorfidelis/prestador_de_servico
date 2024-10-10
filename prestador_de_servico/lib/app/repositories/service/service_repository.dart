
import 'package:prestador_de_servico/app/models/service/service.dart';

abstract class ServiceRepository {

  Future<List<Service>> getAll();
  Future<List<Service>> getByServiceCategoryId({required String serviceCategoryId});
  Future<Service> getById({required String id});
  Future<List<Service>> getNameContained({required String name});
  Future<List<Service>> getUnsync({required DateTime dateLastSync});
  Future<String> insert({required Service service});
  Future<void> update({required Service service});
  Future<void> deleteById({required String id});
  Future<bool> existsById({required String id});
}