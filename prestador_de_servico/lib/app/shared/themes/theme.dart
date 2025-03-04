import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/themes/custom_colors.dart';

ThemeData mainTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff0E293C),
    onPrimary: Colors.white,
    secondary: Color(0xff1976D2),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    primaryContainer: Color(0xff0E293C),
    onPrimaryContainer: Colors.white,
    shadow: Color(0x50000000),
  ),
  extensions: <ThemeExtension<CustomColors>>[
    CustomColors(
      edit: const Color(0xffEC942C),
      onEdit: Colors.white,
      pending: const Color(0xffEC942C),
      onPending: Colors.white,
      confirm: const Color(0xff1976D2),
      onConfirm: Colors.white,
      cancel: const Color(0xffE70000),
      onCancel: Colors.white,
      remove: const Color(0xffE70000),
      onRemove: Colors.white,
      conflict: const Color(0xffE70000),
      onConflict: Colors.white,
      money: const Color(0xff00891E),
      onMoney: Colors.white,
    ),
  ],
);
