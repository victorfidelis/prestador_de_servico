import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? edit;
  final Color? onEdit;
  final Color? pending;
  final Color? onPending;
  final Color? confirm;
  final Color? onConfirm;
  final Color? cancel;
  final Color? onCancel;
  final Color? remove;
  final Color? onRemove;
  final Color? conflict;
  final Color? onConflict;
  final Color? money;
  final Color? onMoney;

  CustomColors({
    this.edit,
    this.onEdit,
    this.pending,
    this.onPending,
    this.confirm,
    this.onConfirm,
    this.cancel,
    this.onCancel,
    this.remove,
    this.onRemove,
    this.conflict,
    this.onConflict,
    this.money,
    this.onMoney,
  });


  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      edit: Color.lerp(edit, other.edit, t),
      onEdit: Color.lerp(onEdit, other.onEdit, t),
      pending: Color.lerp(pending, other.pending, t),
      onPending: Color.lerp(onPending, other.onPending, t),
      cancel: Color.lerp(cancel, other.cancel, t),
      onCancel: Color.lerp(onCancel, other.onCancel, t),
      confirm: Color.lerp(confirm, other.confirm, t),
      onConfirm: Color.lerp(onConfirm, other.onConfirm, t),
      remove: Color.lerp(remove, other.remove, t),
      onRemove: Color.lerp(onRemove, other.onRemove, t),
      conflict: Color.lerp(conflict, other.conflict, t),
      onConflict: Color.lerp(onConflict, other.onConflict, t),
      money: Color.lerp(money, other.money, t),
      onMoney: Color.lerp(onMoney, other.onMoney, t),
    );
  }

  @override
  CustomColors copyWith({
    Color? edit,
    Color? onEdit,
    Color? pending,
    Color? onPending,
    Color? confirm,
    Color? onConfirm,
    Color? cancel,
    Color? onCancel,
    Color? remove,
    Color? onRemove,
    Color? conflict,
    Color? onConflict,
    Color? money,
    Color? onMoney,
  }) {
    return CustomColors(
      edit: edit ?? this.edit,
      onEdit: onEdit ?? this.onEdit,
      pending: pending ?? this.pending,
      onPending: onPending ?? this.onPending,
      confirm: confirm ?? this.confirm,
      onConfirm: onConfirm ?? this.onConfirm,
      cancel: cancel ?? this.cancel,
      onCancel: onCancel ?? this.onCancel,
      remove: remove ?? this.remove,
      onRemove: onRemove ?? this.onRemove,
      conflict: conflict ?? this.conflict,
      onConflict: onConflict ?? this.onConflict,
      money: money ?? this.money,
      onMoney: onMoney ?? this.onMoney,
    );
  }
}
