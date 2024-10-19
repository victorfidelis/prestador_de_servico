import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/services/sync/sync_service_category_service.dart';
import 'package:prestador_de_servico/app/shared/either/either_extension.dart';
import 'package:prestador_de_servico/app/states/app/app_state.dart';

class SyncController extends ChangeNotifier {
  final SyncServiceCategoryService syncServiceCategoryService;

SyncController({required this.syncServiceCategoryService}) {
    init();
  }

  SyncState _state = Syncing();
  SyncState get state => _state;

  void _changeState(currentState) {
    _state = currentState;
    notifyListeners();
  }

  Future<void> init() async {
    _changeState(await _syncData());
  }

  Future<SyncState> _syncData() async {
    final syncEither = await syncServiceCategoryService.synchronize();

    if (syncEither.isLeft) {
      return SyncError(syncEither.left!.message);
    }

    return Synchronized();
  }
}
