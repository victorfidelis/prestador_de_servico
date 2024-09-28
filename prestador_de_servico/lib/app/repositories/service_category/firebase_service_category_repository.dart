import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_adapter.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_model.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';

class FirebaseServiceCategoryRepository implements ServiceCategoryRepository {
  final serviceCategoriesCollection =
      FirebaseFirestore.instance.collection('serviceCategories');

  @override
  Future<String?> add({required ServiceCartegoryModel serviceCategory}) async {
    DocumentReference docRef = await serviceCategoriesCollection.add(
      ServiceCartegoryAdapter.toFirebaseMap(
        serviceCategory: serviceCategory,
      ),
    );
    DocumentSnapshot docSnap = await docRef.get();
    return docSnap.id;
  }

  @override
  Future<bool> deleteById({required String id}) async {
    await serviceCategoriesCollection.doc(id).delete();
    return true;
  }

  @override
  Future<ServiceCartegoryModel> getById({required String id}) async {
    DocumentSnapshot docSnap = await serviceCategoriesCollection.doc(id).get();
    ServiceCartegoryModel serviceCartegory =
        ServiceCartegoryAdapter.fromDocumentSnapshot(doc: docSnap);
    return serviceCartegory;
  }

  @override
  Future<List<ServiceCartegoryModel>> getNameContained(
      {required String name}) async {
    QuerySnapshot snapServiceCategories =
        await serviceCategoriesCollection.get();
    List<ServiceCartegoryModel> serviceCategories = snapServiceCategories.docs
        .map(
          (doc) => ServiceCartegoryAdapter.fromDocumentSnapshot(doc: doc),
        )
        .toList();

    serviceCategories = serviceCategories.where((serviceCategory) {
      String upperName = serviceCategory.name.trim().toUpperCase();
      String upperNameSearch = serviceCategory.name.trim().toUpperCase();
      return upperName.contains(upperNameSearch);
    }).toList();

    return serviceCategories;
  }

  @override
  Future<bool> update({required ServiceCartegoryModel serviceCategory}) async {
    await serviceCategoriesCollection.doc(serviceCategory.id).update(
          ServiceCartegoryAdapter.toFirebaseMap(
              serviceCategory: serviceCategory),
        );
    return true;
  }
}
