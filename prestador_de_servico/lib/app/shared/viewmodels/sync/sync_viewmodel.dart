import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/network/network_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_payment_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_day_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_service.dart';
import 'package:prestador_de_servico/app/shared/utils/either/either_extensions.dart';
import 'package:prestador_de_servico/app/shared/sync/sync_state.dart';

class SyncController extends ChangeNotifier {
  final NetworkService networkService;
  final SyncServiceCategoryService syncServiceCategoryService;
  final SyncServiceService syncServiceService;
  final SyncPaymentService syncPaymentService;
  final SyncServiceDayService syncServiceDayService;

  SyncController({
    required this.networkService,
    required this.syncServiceCategoryService,
    required this.syncServiceService,
    required this.syncPaymentService,
    required this.syncServiceDayService,
  });

  SyncState _state = Syncing();
  SyncState get state => _state;

  void _emitState(currentState) {
    _state = currentState;
    notifyListeners();
  }

  Future<void> syncData() async {
    if (await networkService.isConnectedToInternet()) {
      _emitState(await _syncData());
    } else {
      _emitState(NoNetworkToSync());
    }
  }

  Future<SyncState> _syncData() async {
    final syncServiceCategoryEither = await syncServiceCategoryService.synchronize();
    if (syncServiceCategoryEither.isLeft) {
      return SyncError(syncServiceCategoryEither.left!.message);
    }

    final syncServiceEither = await syncServiceService.synchronize();
    if (syncServiceEither.isLeft) {
      return SyncError(syncServiceEither.left!.message);
    }

    final syncPaymentEither = await syncPaymentService.synchronize();
    if (syncPaymentEither.isLeft) {
      return SyncError(syncPaymentEither.left!.message);
    }

    final syncServiceDayEither = await syncServiceDayService.synchronize();
    if (syncServiceDayEither.isLeft) {
      return SyncError(syncServiceDayEither.left!.message);
    }

    return Synchronized();
  }
}
