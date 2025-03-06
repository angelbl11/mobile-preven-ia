import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_preven_ia_app/firebase/storage/classes/user_profile.dart';

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

  String extractValidJson(String text) {
    // RegExp para extraer un bloque JSON que comience con { y termine con }
    final regExp = RegExp(r'\{[\s\S]*\}');
    final match = regExp.firstMatch(text);
    if (match != null) {
      return match.group(0)!.trim();
    }
    return text;
  }

  String sanitizeJson(String jsonStr) {
    String sanitized = jsonStr.replaceAll(RegExp(r'```'), '').trim();
    sanitized = extractValidJson(sanitized);
    return sanitized;
  }

  Future<Map<String, dynamic>> createUserAnalysis(
      String uid, String analysis) async {
    try {
      // Limpiar la cadena JSON usando la función de extracción.
      final sanitizedAnalysis = sanitizeJson(analysis);

      // Convertir la cadena JSON a un Map.
      Map<String, dynamic> analysisMap =
          json.decode(sanitizedAnalysis) as Map<String, dynamic>;

      // Crear una referencia en la subcolección "analysis" del usuario con un id autogenerado.
      final analysisRef =
          _firestore.collection('users').doc(uid).collection('analysis').doc();

      // Agregar campos adicionales.
      analysisMap['id'] = analysisRef.id;
      analysisMap['created_at'] = FieldValue.serverTimestamp();
      analysisMap['user_id'] = uid;

      // Guardar el análisis en Firestore.
      await analysisRef.set(analysisMap);

      // Recuperar el documento para obtener los datos actualizados.
      final docSnapshot = await analysisRef.get();
      return docSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
