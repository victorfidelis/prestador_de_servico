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
    DateTime? dateSyncServices,
  }) {
    return Sync(
      dateSyncServiceCategories: dateSyncServiceCategories ?? this.dateSyncServiceCategories,
      dateSyncServices: dateSyncServices ?? this.dateSyncServices,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is Sync) && 
    other.dateSyncServiceCategories == dateSyncServiceCategories && 
    other.dateSyncServices == dateSyncServices;
  }
}
