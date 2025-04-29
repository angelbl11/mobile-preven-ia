import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile_preven_ia_app/core/widgets/pvi_text.dart';
import 'package:mobile_preven_ia_app/core/resources/app_colors.dart';

class LegalTextScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalTextScreen(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PviText(
          text: title,
          variant: TextVariant.headline2,
        ),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PviText(text: title, variant: TextVariant.headline2),
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 200,
                ),
                child: Markdown(
                  data: content,
                  selectable: true,
                  styleSheet:
                      MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
