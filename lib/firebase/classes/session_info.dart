import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_preven_ia_app/firebase/classes/user_step.dart';
import 'package:mobile_preven_ia_app/firebase/classes/monitoring_preferences.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/user_data.dart';

/// Custom class to hold the session info, including the user and additional session data.
class SessionInfo {
  final User user;
  final UserStep nextStep;
  final UserData? userData;
  final DateTime lastLogin;
  final bool isProfileComplete;
  final MonitoringPreferences? monitoringPreferences;

  SessionInfo({
    required this.user,
    required this.nextStep,
    this.userData,
    DateTime? lastLogin,
    this.isProfileComplete = false,
    this.monitoringPreferences,
  }) : lastLogin = lastLogin ?? DateTime.now();

  /// Create a SessionInfo instance from Firestore data
  static Future<SessionInfo> fromFirestore(User user) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = docSnapshot.data() ?? {};
    final userData = UserData.fromMap(docSnapshot.data() ?? {});
    final nextStep = UserStep.fromString(data['next_step'] ?? '');
    final monitoringPreferences =
        MonitoringPreferences.fromMap(data); // Añadido

    return SessionInfo(
      user: user,
      nextStep: nextStep,
      userData: userData,
      monitoringPreferences: monitoringPreferences,
    );
  }

  /// Check if the user needs to complete their profile
  bool get needsProfileCompletion => !isProfileComplete;

  /// Get the user's full name
  String get fullName => userData != null
      ? '${userData!.name} ${userData!.lastName} ${userData!.maternalLastName}'
          .trim()
      : '';

  /// Get the user's age
  int? get age {
    if (userData?.birthDate == null) return null;

    final birth = DateTime.tryParse(userData!.birthDate!);
    if (birth == null) return null;

    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  double? get bmi => userData?.bmi;

  bool get hasGeneticRisks => userData != null
      ? userData!.isGeneticRiskObesity ||
          userData!.isGeneticRiskDiabetes ||
          userData!.isGeneticRiskHypertension
      : false;

  MonitoringPreferences? get monitoringPreferencesData => monitoringPreferences;
}
