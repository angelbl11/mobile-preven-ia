import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class PviScaffold extends StatelessWidget {
  const PviScaffold({
    super.key,
    required this.screenContent,
    this.isRequiredAppBar = false,
    this.appBarTitle,
    this.onRefresh,
  });

  final Widget screenContent;
  final bool isRequiredAppBar;
  final String? appBarTitle;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 100,
        ),
        child: screenContent,
      ),
    );

    if (onRefresh != null) {
      content = RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.background,
        onRefresh: onRefresh!,
        child: content,
      );
    }

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
        child: content,
      ),
    );
  }
}
