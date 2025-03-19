import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile_preven_ia_app/resources/app_fonts.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_scaffold.dart';
import 'package:mobile_preven_ia_app/widgets/pvi_text.dart';

class LegalTextScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalTextScreen(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return PviScaffold(
      isRequiredAppBar: true,
      appBarTitle: title,
      screenContent: Column(
        children: [
          PviText(text: title, style: AppFonts.headline2),
          Markdown(
            data: content,
            selectable: true,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
