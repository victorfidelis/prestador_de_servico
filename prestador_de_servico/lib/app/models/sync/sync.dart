class Sync {
  final DateTime? dateSyncServiceCategory;
  final DateTime? dateSyncService;
  final DateTime? dateSyncPayment;

  bool get existsSyncDateServiceCategories => dateSyncServiceCategory != null;
  bool get existsSyncDateServices => dateSyncService != null;
  bool get existsSyncDatePayments => dateSyncPayment != null;

  Sync({
    this.dateSyncServiceCategory,
    this.dateSyncService,
    this.dateSyncPayment,
  });

  Sync copyWith({
    DateTime? dateSyncServiceCategory,
    DateTime? dateSyncService,
    DateTime? dateSyncPayment,
  }) {
    return Sync(
      dateSyncServiceCategory: dateSyncServiceCategory ?? this.dateSyncServiceCategory,
      dateSyncService: dateSyncService ?? this.dateSyncService,
      dateSyncPayment: dateSyncPayment ?? this.dateSyncPayment,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is Sync) && 
    other.dateSyncServiceCategory == dateSyncServiceCategory && 
    other.dateSyncService == dateSyncService &&
    other.dateSyncPayment == dateSyncPayment;
  }
}
