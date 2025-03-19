import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_controller.g.dart';

@Riverpod(keepAlive: true)
class GeminiController extends _$GeminiController {
  @override
  Gemini build() {
    return Gemini.instance;
  }

  Future<String> prompt(
    List<Part> parts,
  ) async {
    final response = await state.prompt(
      parts: parts,
      generationConfig: GenerationConfig(
        temperature: 0,
        maxOutputTokens: 2048,
      ),
    );
    return response?.output ?? '';
  }
}
