import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_repository_provider.dart';
import 'package:mobile_preven_ia_app/firebase/classes/session_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fire_auth_controller.g.dart';

@Riverpod(keepAlive: true)
class FireAuthController extends _$FireAuthController {
  @override
  Future<SessionInfo?> build() async {
    return null;
  }

  Future<SessionInfo?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final loginResult = await ref
          .read(fireAuthRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      state = AsyncValue.data(loginResult);
      return loginResult;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(fireAuthRepositoryProvider).signOut();
    } catch (error) {
      rethrow;
    }
  }

  // Updated register function returning a LoginResult.
  Future<SessionInfo?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await ref
          .read(fireAuthRepositoryProvider)
          .registerWithEmailAndPassword(email: email, password: password);
      if (user == null) return null;

      final uid = user.uid;
      // Retrieve the user's Firestore document to get the "next_step" value.
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = docSnapshot.data();
      final nextStep = data?['next_step'] ?? 'HEALTH_INFO';

      final loginResult = SessionInfo(user: user, nextStep: nextStep);
      state = AsyncValue.data(loginResult);
      return loginResult;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> completeHealthForm({
    required String uid,
    required String name,
    required String lastName,
    required String maternalLastName,
    required String gender,
    required String birthDate,
    required double weight,
    required double height,
    required bool isGeneticRiskObesity,
    required bool isGeneticRiskDiabetes,
    required bool isGeneticRiskHypertension,
    required bool monitorLDL,
    required bool monitorGlucose,
    required bool monitorIMC,
  }) async {
    try {
      await ref.read(fireAuthRepositoryProvider).completeHealthForm(
            uid: uid,
            name: name,
            lastName: lastName,
            maternalLastName: maternalLastName,
            gender: gender,
            birthDate: birthDate,
            weight: weight,
            height: height,
            isGeneticRiskObesity: isGeneticRiskObesity,
            isGeneticRiskDiabetes: isGeneticRiskDiabetes,
            isGeneticRiskHypertension: isGeneticRiskHypertension,
            monitorLDL: monitorLDL,
            monitorGlucose: monitorGlucose,
            monitorIMC: monitorIMC,
          );
    } catch (error) {
      rethrow;
    }
  }
}
