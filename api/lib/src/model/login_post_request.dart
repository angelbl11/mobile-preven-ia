//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_post_request.g.dart';

/// LoginPostRequest
///
/// Properties:
/// * [phoneNumber] 
/// * [password] 
@BuiltValue()
abstract class LoginPostRequest implements Built<LoginPostRequest, LoginPostRequestBuilder> {
  @BuiltValueField(wireName: r'phoneNumber')
  JsonObject? get phoneNumber;

  @BuiltValueField(wireName: r'password')
  JsonObject? get password;

  LoginPostRequest._();

  factory LoginPostRequest([void updates(LoginPostRequestBuilder b)]) = _$LoginPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginPostRequest> get serializer => _$LoginPostRequestSerializer();
}

class _$LoginPostRequestSerializer implements PrimitiveSerializer<LoginPostRequest> {
  @override
  final Iterable<Type> types = const [LoginPostRequest, _$LoginPostRequest];

  @override
  final String wireName = r'LoginPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginPostRequest object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    LoginPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginPostRequestBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LoginPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginPostRequestBuilder();
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

