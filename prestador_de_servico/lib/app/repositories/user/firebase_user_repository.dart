import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/user/user_adapter.dart';
import 'package:prestador_de_servico/app/models/user/user.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<String?> add({required User user}) async {
    DocumentReference docRef =
        await usersCollection.add(UserAdapter.toFirebaseMap(user: user));
    DocumentSnapshot docSnap = await docRef.get();
    return docSnap.id;
  }

  @override
  Future<User> getById({required String id}) async {
    DocumentSnapshot docSnap = await usersCollection.doc(id).get();
    User user = UserAdapter.fromDocumentSnapshot(doc: docSnap);
    return user;
  }

  @override
  Future<User?> getByEmail({required String email}) async {
    QuerySnapshot querySnap =
        await usersCollection.where('email', isEqualTo: email).get();
    User? user;
    if (querySnap.docs.isNotEmpty) {
      user = UserAdapter.fromDocumentSnapshot(doc: querySnap.docs[0]);
    }
    return user;
  }

  @override
  Future<void> deleteById({required String id}) async {
    await usersCollection.doc(id).delete();
  }

  @override
  Future<void> update({required User user}) async {
    await usersCollection.doc(user.id).update(UserAdapter.toFirebaseMap(user: user));
  }
}
