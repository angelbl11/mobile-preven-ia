import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class PviInfoMessage extends StatelessWidget {
  const PviInfoMessage({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 8,
        children: [
          const Icon(
            LucideIcons.info,
            color: AppColors.primary,
          ),
          Expanded(
            child: PviText(
              text: message,
              style: AppFonts.body1,
            ),
          ),
        ],
      ),
    );
  }
}
