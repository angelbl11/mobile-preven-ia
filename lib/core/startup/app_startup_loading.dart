import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';

/// The widget that shows the loading state of the app startup.
class AppStartupLoading extends StatelessWidget {
  /// Constructor
  const AppStartupLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary,
      child: Center(
        child: SvgPicture.asset(
          'assets/images/logo-white.svg',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
