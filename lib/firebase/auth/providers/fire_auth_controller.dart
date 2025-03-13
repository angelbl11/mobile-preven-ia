import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_repository_provider.dart';
import 'package:mobile_preven_ia_app/firebase/classes/session_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fire_auth_controller.g.dart';

@Riverpod(keepAlive: true)
class FireAuthController extends _$FireAuthController {
  @override
  Future<SessionInfo?> build() async {
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        final sessionInfo = await SessionInfo.fromFirestore(user);
        state = AsyncValue.data(sessionInfo);
      } else {
        state = const AsyncValue.data(null);
      }
    });

    // Return current session if exists
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return SessionInfo.fromFirestore(currentUser);
    }
    return null;
  }

  /// Sign in with email and password
  Future<SessionInfo?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final loginResult = await ref
          .read(fireAuthRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password);

      // Update last login
      if (loginResult != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(loginResult.user.uid)
            .update({'last_login': FieldValue.serverTimestamp()});
      }

      state = AsyncValue.data(loginResult);
      return loginResult;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
      await ref.read(fireAuthRepositoryProvider).signOut();
      state = const AsyncValue.data(null);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  /// Register with email and password
  Future<SessionInfo?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await ref
          .read(fireAuthRepositoryProvider)
          .registerWithEmailAndPassword(email: email, password: password);

      if (user == null) {
        state = const AsyncValue.data(null);
        return null;
      }

      final sessionInfo = await SessionInfo.fromFirestore(user);
      state = AsyncValue.data(sessionInfo);
      return sessionInfo;
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  /// Complete health form and update user profile
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
    required bool monitorWeight,
  }) async {
    try {
      state = const AsyncValue.loading();
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
            monitorWeight: monitorWeight,
          );

      // Refresh session info after profile update
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final sessionInfo = await SessionInfo.fromFirestore(currentUser);
        state = AsyncValue.data(sessionInfo);
      }
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      state = const AsyncValue.loading();
      await ref
          .read(fireAuthRepositoryProvider)
          .changePassword(newPassword, currentPassword);
      await ref.read(fireAuthRepositoryProvider).signOut();
      state = const AsyncValue.data(null);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = const AsyncValue.loading();
      await ref.read(fireAuthRepositoryProvider).resetPassword(email);
      state = const AsyncValue.data(null);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
      rethrow;
    }
  }

  /// Check if user is logged in
  bool get isLoggedIn => state.value != null;

  /// Get current user data
  SessionInfo? get currentSession => state.value;

  /// Check if user needs to complete profile
  bool get needsProfileCompletion =>
      state.value?.needsProfileCompletion ?? true;
}
