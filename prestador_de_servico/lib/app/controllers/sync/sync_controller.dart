import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/network/network_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/states/sync/sync_state.dart';

class SyncController extends ChangeNotifier {
  final NetworkService networkService;
  final SyncServiceCategoryService syncServiceCategoryService;
  final SyncServiceService syncServiceService;

  SyncController({
    required this.networkService,
    required this.syncServiceCategoryService,
    required this.syncServiceService,
  });

  SyncState _state = Syncing();
  SyncState get state => _state;

  void _changeState(currentState) {
    _state = currentState;
    notifyListeners();
  }

  Future<void> syncData() async {
    if (await networkService.isConnectedToInternet()) {
      _changeState(await _syncData());
    } else {
      _changeState(NoNetworkToSync());
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

    return Synchronized();
  }
}
