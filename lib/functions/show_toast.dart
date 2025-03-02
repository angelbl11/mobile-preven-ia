import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/classes/message_status.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';
import 'package:toastification/toastification.dart';

/// Show a toast with the message
void showToast({
  required MessageStatus status,
  required BuildContext context,
  required String message,
  bool isRequiredTitle = false,
  String? customTitle,
}) {
  toastification.show(
    context: context,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(seconds: 5),
    type: status.type,
    alignment: Alignment.bottomLeft,
    title: isRequiredTitle
        ? PviText(
            text: customTitle ?? status.title,
            style: AppFonts.body2,
          )
        : null,
    description: PviText(
      text: message,
      style: AppFonts.body2,
    ),
    primaryColor: status.primaryColor,
    animationDuration: const Duration(milliseconds: 300),
    borderRadius: BorderRadius.circular(10),
    showProgressBar: false,
    closeOnClick: true,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
  );
}
