
abstract class SyncState {}

class Syncing extends SyncState {}

class Synchronized extends SyncState {}

class SyncError extends SyncState {
  final String message;
  SyncError(this.message);
}


