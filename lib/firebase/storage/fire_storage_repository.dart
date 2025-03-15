import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_preven_ia_app/firebase/storage/classes/user_profile.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/monitoring_data.dart';
import 'package:mobile_preven_ia_app/firebase/storage/mappers/weight_history.dart';
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

  Future<Map<String, dynamic>> getUserAnalysisById(
      String uid, String analysisId) async {
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('analysis')
          .doc(analysisId)
          .get();
      return docSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MonitoringData>> getGlucoseAndLDLValuesByDate(String uid) async {
    final userAnalyses = await getUserAnalyses(uid);

    final List<Map<String, dynamic>> results = [];

    final Map<String, List<String>> examAliases = {
      "glucose": ["Glucosa", "Glucemia", "Glucosa en ayunas"],
      "ldl": [
        "LDL",
        "Colesterol LDL directo",
        "Colesterol LDL Directo",
        "Colesterol LDL"
      ],
    };

    String? findExamKey(Map<String, dynamic> exams, List<String> aliases) {
      for (final alias in aliases) {
        if (exams.containsKey(alias)) {
          return alias;
        }
      }
      return null;
    }

    for (final analysis in userAnalyses) {
      final createdAtStr = analysis["created_at"] as String?;
      DateTime? date;
      if (createdAtStr != null) {
        try {
          date = DateTime.parse(createdAtStr);
        } catch (e) {
          rethrow;
        }
      }

      final exams = analysis["exams"] as Map<String, dynamic>?;

      double? glucoseValue;
      double? ldlValue;

      if (exams != null) {
        final glucoseKey = findExamKey(exams, examAliases["glucose"]!);
        if (glucoseKey != null) {
          final rawValue = exams[glucoseKey]["value"] as String?;
          if (rawValue != null) {
            final numericValueStr = rawValue.replaceAll(RegExp(r'[^\d\.]'), '');
            glucoseValue = double.tryParse(numericValueStr);
          }
        }

        final ldlKey = findExamKey(exams, examAliases["ldl"]!);
        if (ldlKey != null) {
          final rawValue = exams[ldlKey]["value"] as String?;
          if (rawValue != null) {
            final numericValueStr = rawValue.replaceAll(RegExp(r'[^\d\.]'), '');
            ldlValue = double.tryParse(numericValueStr);
          }
        }
      }

      results.add({
        "date": date,
        "glucose": glucoseValue,
        "ldl": ldlValue,
      });
    }

    results.sort((a, b) {
      final dateA = a["date"] as DateTime?;
      final dateB = b["date"] as DateTime?;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateA.compareTo(dateB);
    });
    final mappedRes = results
        .map<MonitoringData>((map) => MonitoringData.fromMap(map))
        .toList();

    return mappedRes;
  }

  Future<void> updateUserWeight(String uid, double newWeight) async {
    try {
      final userProfile = await getUserProfile(uid);
      if (userProfile == null) {
        throw Exception("Usuario no encontrado");
      }
      final double height = userProfile.height;
      if (height <= 0) {
        throw Exception(
            "La altura del usuario no es válida para calcular el IMC");
      }
      final double newBMI = newWeight / (height * height);
      await _firestore.collection('users').doc(uid).update({
        'weight': newWeight,
        'bmi': newBMI,
      });
      final weightHistoryRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('weight_history')
          .doc();
      await weightHistoryRef.set({
        'id': weightHistoryRef.id,
        'weight': newWeight,
        'bmi': newBMI,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WeightHistory>> getUserWeightHistory(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('weight_history')
          .orderBy('created_at', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => WeightHistory.fromMap(doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfilePicture(String uid, File newProfilePicture) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');

      await storageRef.putFile(newProfilePicture);

      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'photo_url': imageUrl,
      });
    } catch (e) {
      rethrow;
    }
  }
}
