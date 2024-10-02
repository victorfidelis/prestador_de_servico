import 'package:flutter/material.dart';
import 'package:prestador_de_servico/app/shared/notifications/custom_notifications.dart';

class CustomNotificationsImplement implements CustomNotifications {
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

  @override
  Future<void> showSuccessAlert({
    required BuildContext context,
    required String title,
    required String content,
    Function()? confirmCallback,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (confirmCallback != null) {
                    confirmCallback();
                  }
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  @override
  Future<void> showQuestionAlert({
    required BuildContext context,
    required String title,
    required String content,
    Function()? confirmCallback,
    Function()? cancelCallback,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (confirmCallback != null) {
                    confirmCallback();
                  }
                },
                child: const Text('Sim'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (cancelCallback != null) {
                    cancelCallback();
                  }
                },
                child: const Text('Não'),
              ),
            ],
          );
        });
  }
}
