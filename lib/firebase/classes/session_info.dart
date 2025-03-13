import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Custom class to hold the session info, including the user and additional session data.
class SessionInfo {
  final User user;
  final String nextStep;
  final Map<String, dynamic>? userData;
  final DateTime lastLogin;
  final bool isProfileComplete;

  SessionInfo({
    required this.user,
    required this.nextStep,
    this.userData,
    DateTime? lastLogin,
    this.isProfileComplete = false,
  }) : lastLogin = lastLogin ?? DateTime.now();

  /// Create a SessionInfo instance from Firestore data
  static Future<SessionInfo> fromFirestore(User user) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = docSnapshot.data() ?? {};
    final nextStep = data['next_step'] ?? 'HEALTH_INFO';
    final isProfileComplete = data['next_step'] == 'COMPLETED' ? true : false;

    return SessionInfo(
      user: user,
      nextStep: nextStep,
      userData: data,
      isProfileComplete: isProfileComplete,
    );
  }

  /// Check if the user needs to complete their profile
  bool get needsProfileCompletion => !isProfileComplete;

  /// Get the user's full name
  String get fullName {
    final name = userData?['name'] ?? '';
    final lastName = userData?['last_name'] ?? '';
    final maternalLastName = userData?['maternal_last_name'] ?? '';
    return '$name $lastName $maternalLastName'.trim();
  }

  /// Get the user's age
  int? get age {
    final birthDate = userData?['birth_date'];
    if (birthDate == null) return null;

    final birth = DateTime.tryParse(birthDate);
    if (birth == null) return null;

    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  /// Get user's BMI
  double? get bmi => userData?['bmi'];

  /// Check if user has genetic risks
  bool get hasGeneticRisks {
    return (userData?['is_genetic_risk_obesity'] ?? false) ||
        (userData?['is_genetic_risk_diabetes'] ?? false) ||
        (userData?['is_genetic_risk_hypertension'] ?? false);
  }

  /// Get monitoring preferences
  Map<String, bool> get monitoringPreferences {
    return {
      'ldl': userData?['monitor_ldl'] ?? false,
      'glucose': userData?['monitor_glucose'] ?? false,
      'bmi': userData?['monitor_imc'] ?? false,
    };
  }
}
