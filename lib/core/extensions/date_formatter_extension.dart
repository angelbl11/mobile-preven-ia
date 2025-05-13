import 'package:intl/intl.dart';

extension DateFormatterExtension on String {
  String toFormattedDate() {
    try {
      final date = DateTime.parse(this);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return this;
    }
  }

  String toFormattedDateTime() {
    try {
      final date = DateTime.parse(this);
      return DateFormat('dd-MM-yyyy HH:mm').format(date);
    } catch (e) {
      return this;
    }
  }

  String toFormattedTime() {
    try {
      final date = DateTime.parse(this);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return this;
    }
  }
}
