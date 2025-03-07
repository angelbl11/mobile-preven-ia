import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_preven_ia_app/firebase/storage/classes/user_profile.dart';
import 'package:mobile_preven_ia_app/utils/sanitize_json.dart';

class FireStorageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final userProfile = UserProfile.fromMap(data);
        return userProfile;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createUserAnalysis(
      String uid, String analysis) async {
    try {
      final sanitizedAnalysis = sanitizeJson(analysis);

      Map<String, dynamic> analysisMap =
          json.decode(sanitizedAnalysis) as Map<String, dynamic>;

      final analysisRef =
          _firestore.collection('users').doc(uid).collection('analysis').doc();

      analysisMap['id'] = analysisRef.id;
      analysisMap['created_at'] = DateTime.now().toIso8601String();
      analysisMap['user_id'] = uid;

      await analysisRef.set(analysisMap);

      final docSnapshot = await analysisRef.get();
      return docSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getUserAnalyses(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('analysis')
          .orderBy('created_at', descending: true)
          .get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
