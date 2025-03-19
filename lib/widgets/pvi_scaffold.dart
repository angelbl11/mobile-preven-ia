import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class PviScaffold extends StatelessWidget {
  const PviScaffold(
      {super.key,
      required this.screenContent,
      this.isRequiredAppBar = false,
      this.appBarTitle});

  final Widget screenContent;
  final bool isRequiredAppBar;
  final String? appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isRequiredAppBar
          ? AppBar(
              title: PviText(
                text: appBarTitle ?? '',
                style: AppFonts.headline2,
              ),
              backgroundColor: AppColors.background,
            )
          : null,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: SingleChildScrollView(
            child: screenContent,
          ),
        ),
      ),
    );
  }
}
