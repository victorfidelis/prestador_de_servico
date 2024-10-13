import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory_adapter.dart';
import 'package:prestador_de_servico/app/models/service_category/service_cartegory.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/service_category/service_category_repository.dart';

class FirebaseServiceCategoryRepository implements ServiceCategoryRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<List<ServiceCategory>> getAll() async {
    final serviceCategoriesCollection =
        FirebaseFirestore.instance.collection('serviceCategories');
    QuerySnapshot snapServiceCategories = await serviceCategoriesCollection
        .where('isDeleted', isEqualTo: false)
        .get();
    List<ServiceCategory> serviceCategories = snapServiceCategories.docs
        .map(
          (doc) => ServiceCartegoryAdapter.fromDocumentSnapshot(doc: doc),
        )
        .toList();

    return serviceCategories;
  }

  @override
  Future<ServiceCategory> getById({required String id}) async {
    final serviceCategoriesCollection =
        FirebaseFirestore.instance.collection('serviceCategories');
    DocumentSnapshot docSnap = await serviceCategoriesCollection.doc(id).get();
    ServiceCategory serviceCartegory =
        ServiceCartegoryAdapter.fromDocumentSnapshot(doc: docSnap);
    return serviceCartegory;
  }

  @override
  Future<List<ServiceCategory>> getNameContained({required String name}) async {
    List<ServiceCategory> serviceCategories = await getAll();

    serviceCategories = serviceCategories.where((serviceCategory) {
      String upperName = serviceCategory.name.trim().toUpperCase();
      String upperNameSearch = serviceCategory.name.trim().toUpperCase();
      return upperName.contains(upperNameSearch);
    }).toList();

    return serviceCategories;
  }

  @override
  Future<List<ServiceCategory>> getUnsync(
      {required DateTime dateLastSync}) async {
    final serviceCategoriesCollection =
        FirebaseFirestore.instance.collection('serviceCategories');
    Timestamp timestampLastSync = Timestamp.fromDate(dateLastSync);
    QuerySnapshot snapServiceCategories = await serviceCategoriesCollection
        .where('dateSync', isGreaterThan: timestampLastSync)
        .get();

    List<ServiceCategory> serviceCategories = snapServiceCategories.docs
        .map(
          (doc) => ServiceCartegoryAdapter.fromDocumentSnapshot(doc: doc),
        )
        .toList();

    return serviceCategories;
  }

  @override
  Future<String> insert({required ServiceCategory serviceCategory}) async {
    final serviceCategoriesCollection =
        FirebaseFirestore.instance.collection('serviceCategories');
    DocumentReference docRef = await serviceCategoriesCollection.add(
      ServiceCartegoryAdapter.toFirebaseMap(
        serviceCategory: serviceCategory,
      ),
    );
    DocumentSnapshot docSnap = await docRef.get();
    return docSnap.id;
  }

  @override
  Future<void> update({required ServiceCategory serviceCategory}) async {
    final serviceCategoriesCollection =
        FirebaseFirestore.instance.collection('serviceCategories');
    await serviceCategoriesCollection.doc(serviceCategory.id).update(
          ServiceCartegoryAdapter.toFirebaseMap(
              serviceCategory: serviceCategory),
        );
  }

  @override
  Future<void> deleteById({required String id}) async {
    final serviceCategoriesCollection =
        FirebaseFirestore.instance.collection('serviceCategories');
    DocumentReference doc = serviceCategoriesCollection.doc(id);

    ServiceCategory serviceCategory =
        ServiceCartegoryAdapter.fromDocumentSnapshot(
      doc: await doc.get(),
    );
    serviceCategory = serviceCategory.copyWith(isDeleted: true);

    await doc.update(
      ServiceCartegoryAdapter.toFirebaseMap(serviceCategory: serviceCategory),
    );
  }

  @override
  Future<bool> existsById({required String id}) {
    return Future.value(false);
  }
}
