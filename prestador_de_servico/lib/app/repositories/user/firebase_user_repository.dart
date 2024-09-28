import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/user/user_adapter.dart';
import 'package:prestador_de_servico/app/models/user/user_model.dart';
import 'package:prestador_de_servico/app/repositories/user/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<String?> add({required UserModel user}) async {
    DocumentReference docRef =
        await usersCollection.add(UserAdapter.toFirebaseMap(user: user));
    DocumentSnapshot docSnap = await docRef.get();
    return docSnap.id;
  }

  @override
  Future<UserModel> getById({required String id}) async {
    DocumentSnapshot docSnap = await usersCollection.doc(id).get();
    UserModel user = UserAdapter.fromDocumentSnapshot(doc: docSnap);
    return user;
  }

  @override
  Future<UserModel?> getByEmail({required String email}) async {
    QuerySnapshot querySnap =
        await usersCollection.where('email', isEqualTo: email).get();
    UserModel? user;
    if (querySnap.docs.isNotEmpty) {
      user = UserAdapter.fromDocumentSnapshot(doc: querySnap.docs[0]);
    }
    return user;
  }

  @override
  Future<bool> deleteById({required String id}) async {
    await usersCollection.doc(id).delete();
    return true;
  }

  @override
  Future<bool> update({required UserModel user}) async {
    await usersCollection.doc(user.id).update(UserAdapter.toFirebaseMap(user: user));
    return true;
  }
}
