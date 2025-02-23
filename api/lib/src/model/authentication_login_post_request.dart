//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'authentication_login_post_request.g.dart';

/// AuthenticationLoginPostRequest
///
/// Properties:
/// * [phoneNumber] 
/// * [password] 
@BuiltValue()
abstract class AuthenticationLoginPostRequest implements Built<AuthenticationLoginPostRequest, AuthenticationLoginPostRequestBuilder> {
  @BuiltValueField(wireName: r'phoneNumber')
  String? get phoneNumber;

  @BuiltValueField(wireName: r'password')
  String? get password;

  AuthenticationLoginPostRequest._();

  factory AuthenticationLoginPostRequest([void updates(AuthenticationLoginPostRequestBuilder b)]) = _$AuthenticationLoginPostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthenticationLoginPostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthenticationLoginPostRequest> get serializer => _$AuthenticationLoginPostRequestSerializer();
}

class _$AuthenticationLoginPostRequestSerializer implements PrimitiveSerializer<AuthenticationLoginPostRequest> {
  @override
  final Iterable<Type> types = const [AuthenticationLoginPostRequest, _$AuthenticationLoginPostRequest];

  @override
  final String wireName = r'AuthenticationLoginPostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthenticationLoginPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.phoneNumber != null) {
      yield r'phoneNumber';
      yield serializers.serialize(
        object.phoneNumber,
        specifiedType: const FullType(String),
      );
    }
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthenticationLoginPostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthenticationLoginPostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phoneNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phoneNumber = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  AuthenticationLoginPostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthenticationLoginPostRequestBuilder();
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

