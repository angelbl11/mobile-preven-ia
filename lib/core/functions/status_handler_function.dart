import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/core/classes/message_status.dart';
import 'package:mobile_preven_ia_app/core/functions/show_loader_dialog.dart';
import 'package:mobile_preven_ia_app/core/functions/show_toast.dart';

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

      if (e is DioException) {
        final response = e.response;
        if (response != null && response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          errorMessage =
              (data['readable_message'] ?? data['message'] ?? e.message)
                  .toString();
        } else {
          errorMessage = e.message ?? 'Oops! Ocurrió un error';
        }
        if (!context.mounted) return;
        showToast(
          status: MessageStatus.error,
          context: context,
          message: errorMessage,
          isRequiredTitle: true,
        );
      } else {
        errorMessage = e.toString();
      }

      // Close the dialog on failure
      Navigator.of(context, rootNavigator: true).pop();

      if (onFailCallBack != null) {
        onFailCallBack(errorMessage);
      }
    }
  }
}
