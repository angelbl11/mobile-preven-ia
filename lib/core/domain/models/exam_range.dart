enum ExamRange {
  low,
  onRange,
  high;

  factory ExamRange.fromString(String value) {
    return ExamRange.values.firstWhere(
      (range) => range.name.toUpperCase() == value.toUpperCase(),
      orElse: () => ExamRange.onRange,
    );
  }
}
