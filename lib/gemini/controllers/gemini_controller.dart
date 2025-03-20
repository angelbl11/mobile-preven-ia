import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_controller.g.dart';

@riverpod
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
      model: 'gemini-1.5-flash',
      generationConfig: GenerationConfig(
        temperature: 0.3,
        topP: 0.85,
        topK: 40,
        maxOutputTokens: 8192,
      ),
    );
    return response?.output ?? '';
  }
}
