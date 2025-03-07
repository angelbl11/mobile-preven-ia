String extractValidJson(String text) {
  final regExp = RegExp(r'\{[\s\S]*\}');
  final match = regExp.firstMatch(text);
  if (match != null) {
    return match.group(0)!.trim();
  }
  return text;
}
