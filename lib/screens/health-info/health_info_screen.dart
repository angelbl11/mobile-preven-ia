import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/screens/health-info/widgets/health_form.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_scaffold.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class HealthInfoScreen extends ConsumerStatefulWidget {
  const HealthInfoScreen({super.key});

  @override
  ConsumerState<HealthInfoScreen> createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends ConsumerState<HealthInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return PviScaffold(
      screenContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 22,
        children: [
          PviText(
            text: 'Completa tu perfil',
            style: AppFonts.headline1,
          ),
          PviText(
            text: 'Ayúdanos a mejorar la precisión de tus resultados',
            style: AppFonts.subtitle2,
          ),
          const HealthForm(),
        ],
      ),
    );
  }
}
