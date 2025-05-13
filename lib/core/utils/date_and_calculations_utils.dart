extension StringToDateTimeExtension on String {
  DateTime? toDateTime() {
    try {
      final parts = split('-');
      if (parts.length != 3) return null;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}

extension DateTimeAgeExtension on DateTime {
  int calculateAge() {
    final today = DateTime.now();
    int age = today.year - year;
    if (today.month < month || (today.month == month && today.day < day)) {
      age--;
    }
    return age;
  }
}

extension StringToDoubleExtension on String {
  double? toDouble() {
    try {
      return double.parse(replaceAll(',', '.'));
    } catch (e) {
      return null;
    }
  }
}
