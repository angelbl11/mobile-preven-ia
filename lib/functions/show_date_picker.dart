import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/extensions/date_formatter_extension.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';

Future<DateTime?> showPlatformDatePicker(
    BuildContext context, TextEditingController controller) async {
  DateTime? selectedDate;
  if (Platform.isIOS) {
    selectedDate = await _showCupertinoDatePicker(context);
  } else {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
  }

  if (selectedDate != null) {
    controller.text = selectedDate.toIso8601String().toFormattedDate();
  }

  return selectedDate;
}

Future<DateTime?> _showCupertinoDatePicker(BuildContext context) {
  DateTime selectedDate = DateTime(2000, 1, 1);
  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        top: false,
        child: Container(
          height: 260,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Confirmar'),
                onPressed: () {
                  Navigator.of(context).pop(selectedDate);
                },
              )
            ],
          ),
        ),
      );
    },
  );
}
