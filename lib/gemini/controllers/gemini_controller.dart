import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_controller.g.dart';

@Riverpod(keepAlive: true)
class GeminiController extends _$GeminiController {
  @override
  Gemini build() {
    return Gemini.instance;
  }
}
