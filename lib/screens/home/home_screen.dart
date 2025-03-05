import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/home/widgets/clinical_results.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            child: SingleChildScrollView(
              child: Column(
                spacing: 22,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/300'),
                      ),
                      PviText(
                        text: '¡Hola, Juan!',
                        style: AppFonts.headline2,
                      ),
                    ],
                  ),
                  PviText(
                    text: 'Estos son tus últimos resultados',
                    style: AppFonts.headline3,
                  ),
                  const ClinicalResults(),
                  const ClinicalResults(),
                  const ClinicalResults(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
