// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth0_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Auth0State {
  Auth0 get auth0 => throw _privateConstructorUsedError;
  Credentials? get credentials => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of Auth0State
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $Auth0StateCopyWith<Auth0State> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Auth0StateCopyWith<$Res> {
  factory $Auth0StateCopyWith(
          Auth0State value, $Res Function(Auth0State) then) =
      _$Auth0StateCopyWithImpl<$Res, Auth0State>;
  @useResult
  $Res call(
      {Auth0 auth0, Credentials? credentials, bool isLoading, String? error});
}

/// @nodoc
class _$Auth0StateCopyWithImpl<$Res, $Val extends Auth0State>
    implements $Auth0StateCopyWith<$Res> {
  _$Auth0StateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Auth0State
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auth0 = null,
    Object? credentials = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      auth0: null == auth0
          ? _value.auth0
          : auth0 // ignore: cast_nullable_to_non_nullable
              as Auth0,
      credentials: freezed == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as Credentials?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Auth0StateImplCopyWith<$Res>
    implements $Auth0StateCopyWith<$Res> {
  factory _$$Auth0StateImplCopyWith(
          _$Auth0StateImpl value, $Res Function(_$Auth0StateImpl) then) =
      __$$Auth0StateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Auth0 auth0, Credentials? credentials, bool isLoading, String? error});
}

/// @nodoc
class __$$Auth0StateImplCopyWithImpl<$Res>
    extends _$Auth0StateCopyWithImpl<$Res, _$Auth0StateImpl>
    implements _$$Auth0StateImplCopyWith<$Res> {
  __$$Auth0StateImplCopyWithImpl(
      _$Auth0StateImpl _value, $Res Function(_$Auth0StateImpl) _then)
      : super(_value, _then);

  /// Create a copy of Auth0State
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? auth0 = null,
    Object? credentials = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$Auth0StateImpl(
      auth0: null == auth0
          ? _value.auth0
          : auth0 // ignore: cast_nullable_to_non_nullable
              as Auth0,
      credentials: freezed == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as Credentials?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$Auth0StateImpl implements _Auth0State {
  const _$Auth0StateImpl(
      {required this.auth0,
      this.credentials,
      this.isLoading = false,
      this.error});

  @override
  final Auth0 auth0;
  @override
  final Credentials? credentials;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'Auth0State(auth0: $auth0, credentials: $credentials, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Auth0StateImpl &&
            (identical(other.auth0, auth0) || other.auth0 == auth0) &&
            (identical(other.credentials, credentials) ||
                other.credentials == credentials) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, auth0, credentials, isLoading, error);

  /// Create a copy of Auth0State
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Auth0StateImplCopyWith<_$Auth0StateImpl> get copyWith =>
      __$$Auth0StateImplCopyWithImpl<_$Auth0StateImpl>(this, _$identity);
}

abstract class _Auth0State implements Auth0State {
  const factory _Auth0State(
      {required final Auth0 auth0,
      final Credentials? credentials,
      final bool isLoading,
      final String? error}) = _$Auth0StateImpl;

  @override
  Auth0 get auth0;
  @override
  Credentials? get credentials;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of Auth0State
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Auth0StateImplCopyWith<_$Auth0StateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
