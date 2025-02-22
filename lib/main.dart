import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/cmd/handlers/app_startup.dart';

Future<void> main() async {
  runApp(
    const ProviderScope(child: AppStartup()),
  );
}
