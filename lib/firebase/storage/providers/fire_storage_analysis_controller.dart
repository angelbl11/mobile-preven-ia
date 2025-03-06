import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fire_storage_analysis_controller.g.dart';

@riverpod
class FireStorageAnalysisController extends _$FireStorageAnalysisController {
  @override
  Future<Map<String, dynamic>?> build() async {
    return null;
  }

  /// Crea y guarda un análisis para el usuario [uid] con la cadena JSON [analysis].
  Future<Map<String, dynamic>?> createUserAnalysis(
      String uid, String analysis) async {
    final userAnalysis = await ref
        .read(fireStorageRepositoryProvider)
        .createUserAnalysis(uid, analysis);
    return userAnalysis;
  }
}
