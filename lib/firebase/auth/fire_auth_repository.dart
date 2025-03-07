import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_preven_ia_app/firebase/classes/session_info.dart';
import 'package:uuid/uuid.dart';

class FireAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in function that returns a SessionInfo containing the user and the STEP info.
  Future<SessionInfo?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;

      // Retrieve the user's Firestore document.
      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final data = docSnapshot.data();
      final nextStep = data?['next_step'] ?? 'COMPLETED';

      return SessionInfo(user: userCredential.user!, nextStep: nextStep);
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      const uuid = Uuid();
      final newUuid = uuid.v4();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'next_step': 'HEALTH_INFO',
        'user_id': newUuid,
        'created_at': DateTime.now().toIso8601String(),
      });

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Complete the health form with additional values and set "next_step" to "COMPLETED".
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
  }) async {
    try {
      // Optionally update the user's display name.
      await _firebaseAuth.currentUser!.updateDisplayName(name);

      // Update the user's Firestore document with the additional profile and health values.
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'last_name': lastName,
        'maternal_last_name': maternalLastName,
        'gender': gender,
        'birth_date': birthDate,
        'weight': weight,
        'height': height,
        'bmi': weight / (height * height),
        'is_genetic_risk_obesity': isGeneticRiskObesity,
        'is_genetic_risk_diabetes': isGeneticRiskDiabetes,
        'is_genetic_risk_hypertension': isGeneticRiskHypertension,
        'next_step': 'COMPLETED',
      });
    } catch (e) {
      rethrow;
    }
  }

  // Sign out remains unchanged.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
