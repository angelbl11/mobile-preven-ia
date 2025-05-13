import 'package:flutter/material.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';

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
    Widget content = screenContent;

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
                variant: TextVariant.headline2,
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
