import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fire_storage_analysis_controller.g.dart';

@riverpod
class FireStorageAnalysisController extends _$FireStorageAnalysisController {
  @override
  Future<Map<String, dynamic>?> build() async {
    return null;
  }

  Future<Map<String, dynamic>?> createUserAnalysis(
      String uid, String analysis) async {
    final userAnalysis = await ref
        .read(fireStorageRepositoryProvider)
        .createUserAnalysis(uid, analysis);
    return userAnalysis;
  }

  Future<List<Map<String, dynamic>>> getUserAnalyses() async {
    final uid = ref.read(fireAuthControllerProvider).value?.user.uid ?? '';
    final userAnalyses =
        await ref.read(fireStorageRepositoryProvider).getUserAnalyses(uid);
    return userAnalyses;
  }

  Future<Map<String, dynamic>> getUserAnalysisById(String analysisId) async {
    final uid = ref.read(fireAuthControllerProvider).value?.user.uid ?? '';
    final userAnalysis = await ref
        .read(fireStorageRepositoryProvider)
        .getUserAnalysisById(uid, analysisId);
    return userAnalysis;
  }
}
