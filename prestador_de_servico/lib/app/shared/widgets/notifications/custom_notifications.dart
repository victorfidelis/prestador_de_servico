import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/widgets/notifications/custom_notications_implement.dart';

abstract class CustomNotifications {
  factory CustomNotifications() {
    return CustomNotificationsImplement();
  }

  void showSnackBar({
    required BuildContext context,
    required String message,
    Function()? undoAction,
    String? undoLabel,
    Duration duration,
  });

  Future<void> showSuccessAlert({
    required BuildContext context,
    required String title,
    required String content,
    Function()? confirmCallback,
  });

  Future<void> showQuestionAlert({
    required BuildContext context,
    required String title,
    required String content,
    Function() confirmCallback,
    Function() cancelCallback,
  });
}
