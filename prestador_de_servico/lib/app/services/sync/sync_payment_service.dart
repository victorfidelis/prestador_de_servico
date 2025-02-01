import 'package:prestador_de_servico/app/models/payment/payment.dart';
import 'package:prestador_de_servico/app/models/sync/sync.dart';
import 'package:prestador_de_servico/app/repositories/payment/payment_repository.dart';
import 'package:prestador_de_servico/app/repositories/sync/sync_repository.dart';
import 'package:prestador_de_servico/app/shared/either/either.dart';
import 'package:prestador_de_servico/app/shared/extensions/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/failure/failure.dart';

class SyncPaymentService {
  final SyncRepository syncRepository;
  final PaymentRepository offlineRepository;
  final PaymentRepository onlineRepository;
  late Sync sync;

  SyncPaymentService({
    required this.syncRepository,
    required this.offlineRepository,
    required this.onlineRepository,
  });
  
  List<Payment> paymentsToSync = [];

  Future<Either<Failure, Unit>> synchronize() async {
    final loadInfoSyncEither = await loadSyncInfo();
    if (loadInfoSyncEither.isLeft) {
      return Either.left(loadInfoSyncEither.left);
    }

    final loadUnsyncedEither = await loadUnsynced();
    if (loadUnsyncedEither.isLeft) {
      return Either.left(loadUnsyncedEither.left);
    }

    final syncUnsyncedEither = await syncUnsynced();
    if (syncUnsyncedEither.isLeft) {
      return Either.left(syncUnsyncedEither.left);
    }

    final updateSyncDateEither = await updateSyncDate();
    if (updateSyncDateEither.isLeft) {
      return Either.left(updateSyncDateEither.left);
    } 

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> loadSyncInfo() async {
    final getSyncEither = await syncRepository.get();
    if (getSyncEither.isLeft) {
      return Either.left(getSyncEither.left);
    }
    sync = getSyncEither.right!;
    return Either.right(unit);
  }
  
  Future<Either<Failure, Unit>> loadUnsynced() async {
    Either getEither;
    if (sync.existsSyncDatePayments) {
      getEither = await onlineRepository.getUnsync(dateLastSync: sync.dateSyncPayment!);
    } else {
      getEither = await onlineRepository.getAll();
    }
    if (getEither.isLeft) {
      return Either.left(getEither.left);
    }

    paymentsToSync = getEither.right!;

    return Either.right(unit);
  }

  Future<Either<Failure, Unit>> syncUnsynced() async {
    for (Payment payment in paymentsToSync) {
      final syncEither = await syncPayment(payment);
      if (syncEither.isLeft) {
        return Either.left(syncEither.left);
      }
    } 
    return Either.right(unit);
  } 

  Future<Either<Failure, Unit>> syncPayment(Payment payment) async {
    if (payment.isDeleted) {
      return await offlineRepository.deleteById(id: payment.id);
    } 
    
    final existsEither = await offlineRepository.existsById(id: payment.id);
    if (existsEither.isLeft) {
      return Either.left(existsEither.left); 
    }

    if (existsEither.right!) {
      return await offlineRepository.update(payment: payment);
    } else {
      final insertEither = await offlineRepository.insert(payment: payment);
      if (insertEither.isLeft) {
        return Either.left(insertEither.left);
      }
      return Either.right(unit);
    }
  }

  Future<Either<Failure, Unit>> updateSyncDate() async {
    if (paymentsToSync.isEmpty) {
      return Either.right(unit);
    }

    DateTime syncDate = getMaxSyncDate();
    final existsEither = await syncRepository.exists(); 
    if (existsEither.isLeft) {
      return Either.left(existsEither.left);
    }

    if (existsEither.right!) {
      return await syncRepository.updatePayment(syncDate: syncDate);
    } else {
      sync = sync.copyWith(dateSyncPayment: syncDate);
      return await syncRepository.insert(sync: sync);
    }
  }

  DateTime getMaxSyncDate() {
    Payment payment = paymentsToSync.reduce(
      (value, element) {
        // Todo objeto vindo da nuvem necessariamente deve ter o syncDate
        // Por esse motivo o operador "!" em "syncDate"
        if (value.syncDate!.compareTo(element.syncDate!) > 0) {
          return value;
        } else {
          return element;
        }
      },
    );
    return payment.syncDate!;
  }
}