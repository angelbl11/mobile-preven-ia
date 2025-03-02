import 'package:firebase_auth/firebase_auth.dart';

/// Custom class to hold the session info, including the user and the STEP info.
class SessionInfo {
  final User user;
  final String nextStep;

  SessionInfo({required this.user, required this.nextStep});
}
