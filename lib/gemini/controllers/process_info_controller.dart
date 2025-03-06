import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_analysis_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_user_controller.dart';
import 'package:mobile_preven_ia_app/gemini/controllers/gemini_controller.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/analyze_without_model_prompt.dart';
import 'package:mobile_preven_ia_app/gemini/prompts/extraction_prompt.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'process_info_controller.g.dart';

@Riverpod(keepAlive: true)
class ProcessInfoController extends _$ProcessInfoController {
  @override
  Future<String?> build() async {
    return null;
  }

  /// Parsea la fecha de nacimiento en formato "DD/MM/YYYY".
  DateTime? _parseBirthDate(String? birthDateStr) {
    if (birthDateStr == null || birthDateStr.isEmpty) return null;
    try {
      final parts = birthDateStr.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  /// Calcula la edad a partir de la fecha de nacimiento.
  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String parseGender(String gender) {
    if (gender == 'M') {
      return 'Masculino';
    }
    return 'Femenino';
  }

  Future<Map<String, dynamic>?> analyzeTextWithoutModel(
      String plainText) async {
    final geminiController = ref.watch(geminiControllerProvider);

    // Primera etapa: extraer datos del texto.
    final extractionResponse = await geminiController.prompt(
      parts: [
        Part.text(extractionPrompt),
        Part.text(plainText),
      ],
    );

    // Obtenemos el perfil del usuario.
    final userProfile =
        await ref.watch(fireStorageUserControllerProvider.future);

    int age = 0;
    final birthDate = _parseBirthDate(userProfile?.birthDate);
    if (birthDate != null) {
      age = _calculateAge(birthDate);
    }

    // Reemplazamos los placeholders en el prompt con los valores reales.
    final modifiedAnalyzePrompt = analyzeWithoutModelPrompt
        .replaceAll('valor_de_IMC', userProfile?.bmi.toString() ?? '0')
        .replaceAll('valor_de_sexo', parseGender(userProfile?.gender ?? 'M'))
        .replaceAll('valor_de_edad', age.toString());

    // Segunda etapa: análisis del texto extraído con los valores actualizados.
    final analysisResponse = await geminiController.prompt(
      parts: [
        Part.text(modifiedAnalyzePrompt),
        Part.text(extractionResponse?.output ?? ''),
      ],
    );

    final analysisOutput = analysisResponse?.output;

    // Persistir el análisis en Firestore si se obtuvo resultado.
    final currentUser = ref.read(fireAuthControllerProvider).value?.user;
    if (analysisOutput != null && currentUser != null) {
      // Aquí obtenemos el análisis persistido, que es un Map<String, dynamic>
      final persistedAnalysis = await ref
          .read(fireStorageAnalysisControllerProvider.notifier)
          .createUserAnalysis(currentUser.uid, analysisOutput);
      return persistedAnalysis;
    }

    return null;
  }
}
