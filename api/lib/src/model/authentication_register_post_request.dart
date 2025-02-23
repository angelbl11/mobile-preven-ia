//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'authentication_register_post_request.g.dart';

/// AuthenticationRegisterPostRequest
///
/// Properties:
/// * [phoneNumber] 
/// * [password] 
/// * [personalInfo] 
@BuiltValue()
abstract class AuthenticationRegisterPostRequest implements Built<AuthenticationRegisterPostRequest, AuthenticationRegisterPostRequestBuilder> {
  @BuiltValueField(wireName: r'phoneNumber')
  JsonObject? get phoneNumber;

  @BuiltValueField(wireName: r'password')
  JsonObject? get password;

  @BuiltValueField(wireName: r'personalInfo')
  JsonObject? get personalInfo;

  AuthenticationRegisterPostRequest._();

  factory AuthenticationRegisterPostRequest([void updates(AuthenticationRegisterPostRequestBuilder b)]) = _$AuthenticationRegisterPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthenticationRegisterPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthenticationRegisterPostRequest> get serializer => _$AuthenticationRegisterPostRequestSerializer();
}

class _$AuthenticationRegisterPostRequestSerializer implements PrimitiveSerializer<AuthenticationRegisterPostRequest> {
  @override
  final Iterable<Type> types = const [AuthenticationRegisterPostRequest, _$AuthenticationRegisterPostRequest];

  @override
  final String wireName = r'AuthenticationRegisterPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthenticationRegisterPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.phoneNumber != null) {
      yield r'phoneNumber';
      yield serializers.serialize(
        object.phoneNumber,
        specifiedType: const FullType(JsonObject),
      );
    }
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType(JsonObject),
      );
    }
    if (object.personalInfo != null) {
      yield r'personalInfo';
      yield serializers.serialize(
        object.personalInfo,
        specifiedType: const FullType(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthenticationRegisterPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthenticationRegisterPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phoneNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.phoneNumber = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.password = valueDes;
          break;
        case r'personalInfo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.personalInfo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthenticationRegisterPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthenticationRegisterPostRequestBuilder();
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

