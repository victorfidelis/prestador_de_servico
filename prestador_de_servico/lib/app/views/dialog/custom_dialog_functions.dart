import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/views/dialog/dialog_functions.dart';

class CustomDialogFunctions implements DialogFunctions {

  @override
  void showSnackBar({
    required BuildContext context,
    required String message,
    Function()? undoAction,
    String? undoLabel,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: undoAction == null && undoLabel == null
            ? null
            : SnackBarAction(
                label: undoLabel ?? '',
                onPressed: undoAction ?? () {},
              ),
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }
}