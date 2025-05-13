import 'package:json_annotation/json_annotation.dart';

part 'monitoring_data.g.dart';

@JsonSerializable()
class MonitoringData {
  final String? userId;
  final MonitoringParameters data;

  MonitoringData({
    this.userId,
    required this.data,
  });

  factory MonitoringData.fromJson(Map<String, dynamic> json) =>
      _$MonitoringDataFromJson(json);

  Map<String, dynamic> toJson() => _$MonitoringDataToJson(this);
}

@JsonSerializable()
class MonitoringParameters {
  final Diabetes? diabetes;
  final Obesity? obesity;
  final Hypertension? hypertension;

  MonitoringParameters({
    this.diabetes,
    this.obesity,
    this.hypertension,
  });

  factory MonitoringParameters.fromJson(Map<String, dynamic> json) =>
      _$MonitoringParametersFromJson(json);

  Map<String, dynamic> toJson() => _$MonitoringParametersToJson(this);
}

@JsonSerializable()
class Diabetes {
  final List<Glucose> glucose;

  Diabetes({required this.glucose});

  factory Diabetes.fromJson(Map<String, dynamic> json) =>
      _$DiabetesFromJson(json);

  Map<String, dynamic> toJson() => _$DiabetesToJson(this);
}

@JsonSerializable()
class Glucose {
  final double value;
  final DateTime date;

  Glucose({
    required this.value,
    required this.date,
  });

  factory Glucose.fromJson(Map<String, dynamic> json) =>
      _$GlucoseFromJson(json);

  Map<String, dynamic> toJson() => _$GlucoseToJson(this);
}

@JsonSerializable()
class Obesity {
  final List<Weight> weight;

  Obesity({required this.weight});

  factory Obesity.fromJson(Map<String, dynamic> json) =>
      _$ObesityFromJson(json);

  Map<String, dynamic> toJson() => _$ObesityToJson(this);
}

@JsonSerializable()
class Weight {
  final double value;
  final double bmi;
  final DateTime date;

  Weight({
    required this.value,
    required this.bmi,
    required this.date,
  });

  factory Weight.fromJson(Map<String, dynamic> json) => _$WeightFromJson(json);

  Map<String, dynamic> toJson() => _$WeightToJson(this);
}

@JsonSerializable()
class Hypertension {
  final List<BloodPressure> bloodPressure;

  Hypertension({required this.bloodPressure});

  factory Hypertension.fromJson(Map<String, dynamic> json) =>
      _$HypertensionFromJson(json);

  Map<String, dynamic> toJson() => _$HypertensionToJson(this);
}

@JsonSerializable()
class BloodPressure {
  final int systolic;
  final int diastolic;
  final DateTime date;

  BloodPressure({
    required this.systolic,
    required this.diastolic,
    required this.date,
  });

  factory BloodPressure.fromJson(Map<String, dynamic> json) =>
      _$BloodPressureFromJson(json);

  Map<String, dynamic> toJson() => _$BloodPressureToJson(this);
}
