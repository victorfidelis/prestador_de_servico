class Sync {
  final DateTime? dateSyncServiceCategories; 
  final DateTime? dateSyncService; 

  Sync({
    this.dateSyncServiceCategories,
    this.dateSyncService,
  });
  

  Sync copyWith({
    DateTime? dateSyncServiceCategories,
    DateTime? dateSyncService,
  }) {
    return Sync(
      dateSyncServiceCategories: dateSyncServiceCategories ?? this.dateSyncServiceCategories,
      dateSyncService: dateSyncService ?? this.dateSyncService,
    );
  }
}
