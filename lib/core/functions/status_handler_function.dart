import 'dart:async';
import 'dart:convert';

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
      print('Error Dio: $e');
      String errorMessage = 'Ocurrió un error inesperado.';

      if (e is DioException) {
        final response = e.response;
        if (response != null) {
          try {
            // Try to get the error message from the response data
            final responseData = response.data;
            if (responseData is Map<String, dynamic>) {
              // Check for message in different possible locations
              errorMessage = (responseData['message'] ??
                      responseData['error'] ??
                      responseData['errorMessage'] ??
                      errorMessage)
                  .toString();
            } else if (responseData is String) {
              try {
                final jsonData = jsonDecode(responseData);
                if (jsonData is Map<String, dynamic>) {
                  errorMessage = (jsonData['message'] ??
                          jsonData['error'] ??
                          jsonData['errorMessage'] ??
                          errorMessage)
                      .toString();
                }
              } catch (parseError) {
                errorMessage = responseData;
              }
            } else if (responseData is List<int>) {
              final responseString = String.fromCharCodes(responseData);
              try {
                final jsonData = jsonDecode(responseString);
                if (jsonData is Map<String, dynamic>) {
                  errorMessage = (jsonData['message'] ??
                          jsonData['error'] ??
                          jsonData['errorMessage'] ??
                          errorMessage)
                      .toString();
                }
              } catch (parseError) {
                errorMessage = responseString;
              }
            }
          } catch (parseError) {
            // If we can't parse the response, use a more specific error message
            switch (response.statusCode) {
              case 404:
                errorMessage = 'No se encontró el recurso solicitado.';
                break;
              case 500:
                errorMessage = 'Error interno del servidor.';
                break;
              default:
                errorMessage =
                    'Error en la respuesta del servidor (${response.statusCode}).';
            }
          }
        } else {
          errorMessage = 'No se recibió respuesta del servidor.';
        }

        if (!context.mounted) return;
        showToast(
          status: MessageStatus.error,
          context: context,
          message: errorMessage,
        );
      } else {
        errorMessage = e.toString();
      }

      // Close the dialog on failure
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (onFailCallBack != null) {
        onFailCallBack(errorMessage);
      }
    }
  }
}
