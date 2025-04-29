import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// ShowLoaderDialog
void showLoaderDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Lottie.asset(
          'assets/lotties/loader.json',
          width: 140,
          height: 140,
        ),
      );
    },
  );
}
