import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/dialog/custom_dialog_functions.dart';

abstract class DialogFunctions {
  factory DialogFunctions() {
    return CustomDialogFunctions();
  }

  void showSnackBar({
    required BuildContext context,
    required String message,
    Function()? undoAction,
    String? undoLabel,
    Duration duration,
  });
}