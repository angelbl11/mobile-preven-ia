import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_preven_ia_app/core/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

class PviLoader extends StatelessWidget {
  /// Constructor
  const PviLoader({super.key, this.customLoaderText = ''});

  /// Custom loader text
  final String customLoaderText;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lotties/loader.json',
                  width: 250, height: 250),
              PviText(
                text: customLoaderText,
                variant: TextVariant.headline3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
