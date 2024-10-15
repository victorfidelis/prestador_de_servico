class Sync {
  final DateTime? dateSyncServiceCategories; 
  final DateTime? dateSyncServices; 

  bool get existsSyncDateServiceCategories => dateSyncServiceCategories != null;
  bool get existsSyncDateServices => dateSyncServices != null;

  Sync({
    this.dateSyncServiceCategories,
    this.dateSyncServices,
  });

  Sync copyWith({
    DateTime? dateSyncServiceCategories,
    DateTime? dateSyncService,
  }) {
    return Sync(
      dateSyncServiceCategories: dateSyncServiceCategories ?? this.dateSyncServiceCategories,
      dateSyncServices: dateSyncService ?? this.dateSyncServices,
    );
  }
}
