import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/classes/message_status.dart';
import 'package:mobile_preven_ia_app/functions/show_loader_dialog.dart';
import 'package:mobile_preven_ia_app/functions/show_toast.dart';

/// StatusHandlerFunction
class StatusHandlerFunction {
  /// HandleStatus
  static Future<void> handleStatus({
    required BuildContext context,
    required Future<dynamic> action,
    required VoidCallback onSuccessCallBack,
    void Function(String exception)? onFailCallBack,
  }) async {
    showLoaderDialog(context);

    try {
      await action;
      // Close the dialog on success
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      onSuccessCallBack();
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Oops! Ocurrió un error de autenticación';
      } else if (e is FirebaseException) {
        errorMessage =
            e.message ?? 'Oops! Ocurrió un error en la base de datos';
      } else {
        errorMessage = e.toString();
      }

      // Close the loader dialog if still open
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showToast(
          status: MessageStatus.error,
          context: context,
          message: errorMessage,
          isRequiredTitle: true,
        );
      }

      if (onFailCallBack != null) {
        onFailCallBack(errorMessage);
      }
    }
  }
}
