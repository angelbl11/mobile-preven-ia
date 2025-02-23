//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'file_extract_content_post_request.g.dart';

/// FileExtractContentPostRequest
///
/// Properties:
/// * [patientID] 
@BuiltValue()
abstract class FileExtractContentPostRequest implements Built<FileExtractContentPostRequest, FileExtractContentPostRequestBuilder> {
  @BuiltValueField(wireName: r'patientID')
  JsonObject? get patientID;

  FileExtractContentPostRequest._();

  factory FileExtractContentPostRequest([void updates(FileExtractContentPostRequestBuilder b)]) = _$FileExtractContentPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FileExtractContentPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FileExtractContentPostRequest> get serializer => _$FileExtractContentPostRequestSerializer();
}

class _$FileExtractContentPostRequestSerializer implements PrimitiveSerializer<FileExtractContentPostRequest> {
  @override
  final Iterable<Type> types = const [FileExtractContentPostRequest, _$FileExtractContentPostRequest];

  @override
  final String wireName = r'FileExtractContentPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FileExtractContentPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.patientID != null) {
      yield r'patientID';
      yield serializers.serialize(
        object.patientID,
        specifiedType: const FullType(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FileExtractContentPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FileExtractContentPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'patientID':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.patientID = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FileExtractContentPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FileExtractContentPostRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

