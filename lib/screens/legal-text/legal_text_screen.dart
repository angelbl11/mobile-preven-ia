import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile_preven_ia_app/resources/app_colors.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class LegalTextScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalTextScreen(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: PviText(text: title, style: AppFonts.headline2),
          backgroundColor: AppColors.background),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: content,
          selectable: true,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
