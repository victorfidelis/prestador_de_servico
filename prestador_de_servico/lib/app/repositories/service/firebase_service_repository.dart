import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/service/service.dart';
import 'package:prestador_de_servico/app/models/service/service_adapter.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/service/service_repository.dart';

class FirebaseServiceRepository implements ServiceRepository {
  final _firebaseInitializer = FirebaseInitializer();

  @override
  Future<List<Service>> getAll() async {
    final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    QuerySnapshot snapServices =
        await servicesCollection.where('isDeleted', isEqualTo: false).get();

    List<Service> services = snapServices.docs
        .map((doc) => ServiceAdapter.fromDocumentSnapshot(doc: doc))
        .toList();

    return services;
  }

  @override
  Future<List<Service>> getByServiceCategoryId(
      {required String serviceCategoryId}) async {
    final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    QuerySnapshot snapServices = await servicesCollection
        .where('isDeleted', isEqualTo: false)
        .where('serviceCategoryId', isEqualTo: serviceCategoryId)
        .get();

    List<Service> services = snapServices.docs
        .map((doc) => ServiceAdapter.fromDocumentSnapshot(doc: doc))
        .toList();

    return services;
  }

  @override
  Future<Service> getById({required String id}) async {
    final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    DocumentSnapshot docSnap = await servicesCollection.doc(id).get();
    Service service = ServiceAdapter.fromDocumentSnapshot(doc: docSnap);
    return service;
  }

  @override
  Future<List<Service>> getNameContained({required String name}) async {
    List<Service> services = await getAll();

    services = services.where((service) {
      String upperName = service.name.trim().toUpperCase();
      String upperNameSearch = service.name.trim().toUpperCase();
      return upperName.contains(upperNameSearch);
    }).toList();

    return services;
  }

  @override
  Future<List<Service>> getUnsync({required DateTime dateLastSync}) async {
    final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    Timestamp timestampLastSync = Timestamp.fromDate(dateLastSync);
    QuerySnapshot snapService = await servicesCollection
        .where('dateSync', isGreaterThan: timestampLastSync)
        .get();

    List<Service> services = snapService.docs
        .map((doc) => ServiceAdapter.fromDocumentSnapshot(doc: doc))
        .toList();

    return services;
  }

  @override
  Future<String> insert({required Service service}) async {
    final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    DocumentReference docRef = await servicesCollection.add(
      ServiceAdapter.toFirebaseMap(
        service: service,
      ),
    );
    DocumentSnapshot docSnap = await docRef.get();
    return docSnap.id;
  }

  @override
  Future<void> update({required Service service}) async {
    final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    await servicesCollection.doc(service.id).update(
          ServiceAdapter.toFirebaseMap(service: service),
        );
  }

  @override
  Future<void> deleteById({required String id}) async {
    final servicesCollection =
        FirebaseFirestore.instance.collection('services');
    DocumentReference doc = servicesCollection.doc(id);

    Service service = ServiceAdapter.fromDocumentSnapshot(
      doc: await doc.get(),
    );
    service = service.copyWith(isDeleted: true);

    await doc.update(ServiceAdapter.toFirebaseMap(service: service));
  }

  @override
  Future<bool> existsById({required String id}) {
    return Future.value(false);
  }
}
