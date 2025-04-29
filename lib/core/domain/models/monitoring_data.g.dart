// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitoringData _$MonitoringDataFromJson(Map<String, dynamic> json) =>
    MonitoringData(
      userId: json['userId'] as String?,
      data: MonitoringParameters.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonitoringDataToJson(MonitoringData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'data': instance.data,
    };

MonitoringParameters _$MonitoringParametersFromJson(
        Map<String, dynamic> json) =>
    MonitoringParameters(
      diabetes: json['diabetes'] == null
          ? null
          : Diabetes.fromJson(json['diabetes'] as Map<String, dynamic>),
      obesity: json['obesity'] == null
          ? null
          : Obesity.fromJson(json['obesity'] as Map<String, dynamic>),
      hypertension: json['hypertension'] == null
          ? null
          : Hypertension.fromJson(json['hypertension'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MonitoringParametersToJson(
        MonitoringParameters instance) =>
    <String, dynamic>{
      'diabetes': instance.diabetes,
      'obesity': instance.obesity,
      'hypertension': instance.hypertension,
    };

Diabetes _$DiabetesFromJson(Map<String, dynamic> json) => Diabetes(
      glucose: (json['glucose'] as List<dynamic>)
          .map((e) => Glucose.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiabetesToJson(Diabetes instance) => <String, dynamic>{
      'glucose': instance.glucose,
    };

Glucose _$GlucoseFromJson(Map<String, dynamic> json) => Glucose(
      value: (json['value'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$GlucoseToJson(Glucose instance) => <String, dynamic>{
      'value': instance.value,
      'date': instance.date.toIso8601String(),
    };

Obesity _$ObesityFromJson(Map<String, dynamic> json) => Obesity(
      weight: (json['weight'] as List<dynamic>)
          .map((e) => Weight.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ObesityToJson(Obesity instance) => <String, dynamic>{
      'weight': instance.weight,
    };

Weight _$WeightFromJson(Map<String, dynamic> json) => Weight(
      value: (json['value'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$WeightToJson(Weight instance) => <String, dynamic>{
      'value': instance.value,
      'bmi': instance.bmi,
      'date': instance.date.toIso8601String(),
    };

Hypertension _$HypertensionFromJson(Map<String, dynamic> json) => Hypertension(
      bloodPressure: (json['bloodPressure'] as List<dynamic>)
          .map((e) => BloodPressure.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HypertensionToJson(Hypertension instance) =>
    <String, dynamic>{
      'bloodPressure': instance.bloodPressure,
    };

BloodPressure _$BloodPressureFromJson(Map<String, dynamic> json) =>
    BloodPressure(
      systolic: (json['systolic'] as num).toInt(),
      diastolic: (json['diastolic'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$BloodPressureToJson(BloodPressure instance) =>
    <String, dynamic>{
      'systolic': instance.systolic,
      'diastolic': instance.diastolic,
      'date': instance.date.toIso8601String(),
    };
