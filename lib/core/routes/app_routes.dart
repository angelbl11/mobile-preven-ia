import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/screens/auth/auth_screen.dart';
import 'package:mobile_preven_ia_app/screens/health-info/health_info_screen.dart';
import 'package:mobile_preven_ia_app/screens/navigation-handler/navigation_handler_screen.dart';

/// Clase que centraliza todas las rutas de la aplicación
class AppRoutes {
  /// Ruta principal de la aplicación
  static const String home = '/home';

  /// Ruta de autenticación
  static const String auth = '/';

  /// Ruta de información de salud
  static const String healthInfo = '/health-info';

  /// Mapa de rutas de la aplicación
  static Map<String, WidgetBuilder> get routes => {
        home: (_) => NavigationHandlerScreen(),
        auth: (_) => const AuthScreen(),
        healthInfo: (_) => const HealthInfoScreen(),
      };
}
