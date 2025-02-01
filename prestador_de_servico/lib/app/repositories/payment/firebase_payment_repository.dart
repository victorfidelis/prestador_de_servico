import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/models/payment/payment_adapter.dart';
import 'package:prestador_de_servico/app/repositories/config/firebase_initializer.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class FirebasePaymentRepository implements PaymentRepository {
  final _firebaseInitializer = FirebaseInitializer();
  
  @override
  Future<Either<Failure, List<Payment>>> getAll() async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final paymentsCollection = FirebaseFirestore.instance.collection('payments');
      QuerySnapshot snapPayments = await paymentsCollection.where('isDeleted', isEqualTo: false).get();
      List<Payment> payments = snapPayments.docs.map((doc) => PaymentAdapter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(payments);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> update({required Payment payment}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final paymentsCollection = FirebaseFirestore.instance.collection('payments');
      await paymentsCollection.doc(payment.id).update(PaymentAdapter.toFirebaseMap(payment: payment));
      return Either.right(unit);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
  
  @override
  Future<Either<Failure, Unit>> deleteById({required String id}) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, String>> insert({required Payment payment}) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<Payment>>> getUnsync({required DateTime dateLastSync}) async {
    final initializeEither = await _firebaseInitializer.initialize();
    if (initializeEither.isLeft) {
      return Either.left(initializeEither.left);
    }

    try {
      final paymentsCollection = FirebaseFirestore.instance.collection('payments');
      final timestampLastSync = Timestamp.fromDate(dateLastSync);
      final snapPayment = await paymentsCollection.where('dateSync', isGreaterThan: timestampLastSync).get();
      final services = snapPayment.docs.map((doc) => PaymentAdapter.fromDocumentSnapshot(doc: doc)).toList();
      return Either.right(services);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return Either.left(NetworkFailure('Sem conexão com a internet'));
      } else {
        return Either.left(Failure('Firestore error: ${e.message}'));
      }
    }
  }
  
  @override
  Future<Either<Failure, bool>> existsById({required String id}) {
    throw UnimplementedError();
  }
}