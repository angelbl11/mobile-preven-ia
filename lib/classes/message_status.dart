import 'dart:ui';

import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:toastification/toastification.dart';

/// Enum to handle the status of the message
enum MessageStatus {
  /// Success message
  success,

  /// Error message
  error,

  /// Info message
  info,

  /// Warning message
  warning,
}

/// Extension to get the value of the enum as a string
extension MessageStatusX on MessageStatus {
  /// Get the value of the enum as a string
  String get value {
    switch (this) {
      case MessageStatus.success:
        return 'success';
      case MessageStatus.error:
        return 'error';
      case MessageStatus.info:
        return 'info';
      case MessageStatus.warning:
        return 'warning';
    }
  }

  /// Get the title of the enum based on the value
  String get title {
    switch (this) {
      case MessageStatus.success:
        return '¡Listo!';
      case MessageStatus.error:
        return '¡Ocurrió un error!';
      case MessageStatus.info:
        return '¡Atención!';
      case MessageStatus.warning:
        return '¡Advertencia!';
    }
  }

  /// Get the primary color of the enum based on the value
  Color get primaryColor {
    switch (this) {
      case MessageStatus.success:
        return AppColors.success;
      case MessageStatus.error:
        return AppColors.error;
      case MessageStatus.info:
        return AppColors.success;
      case MessageStatus.warning:
        return AppColors.error;
    }
  }

  /// Get the type of the toast based on the value
  ToastificationType get type {
    switch (this) {
      case MessageStatus.success:
        return ToastificationType.success;
      case MessageStatus.error:
        return ToastificationType.error;
      case MessageStatus.info:
        return ToastificationType.info;
      case MessageStatus.warning:
        return ToastificationType.warning;
    }
  }
}
