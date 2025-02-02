class Sync {
  final DateTime? dateSyncServiceCategory;
  final DateTime? dateSyncService;
  final DateTime? dateSyncPayment;
  final DateTime? dateSyncServiceDay;

  bool get existsSyncDateServiceCategories => dateSyncServiceCategory != null;
  bool get existsSyncDateServices => dateSyncService != null;
  bool get existsSyncDatePayments => dateSyncPayment != null;
  bool get existsSyncDateServiceDays => dateSyncServiceDay != null;

  Sync({
    this.dateSyncServiceCategory,
    this.dateSyncService,
    this.dateSyncPayment,
    this.dateSyncServiceDay,
  });

  Sync copyWith({
    DateTime? dateSyncServiceCategory,
    DateTime? dateSyncService,
    DateTime? dateSyncPayment,
    DateTime? dateSyncServiceDay,
  }) {
    return Sync(
      dateSyncServiceCategory: dateSyncServiceCategory ?? this.dateSyncServiceCategory,
      dateSyncService: dateSyncService ?? this.dateSyncService,
      dateSyncPayment: dateSyncPayment ?? this.dateSyncPayment,
      dateSyncServiceDay: dateSyncServiceDay ?? this.dateSyncServiceDay,
    );
  }

  @override
  bool operator ==(Object other) {
    return (other is Sync) && 
    other.dateSyncServiceCategory == dateSyncServiceCategory && 
    other.dateSyncService == dateSyncService &&
    other.dateSyncPayment == dateSyncPayment &&
    other.dateSyncServiceDay == dateSyncServiceDay;
  }
}
