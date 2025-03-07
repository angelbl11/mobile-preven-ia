import 'package:mobile_preven_ia_app/utils/extract_valid_json.dart';

String sanitizeJson(String jsonStr) {
  String sanitized = jsonStr.replaceAll(RegExp(r'```'), '').trim();
  sanitized = extractValidJson(sanitized);
  return sanitized;
}
