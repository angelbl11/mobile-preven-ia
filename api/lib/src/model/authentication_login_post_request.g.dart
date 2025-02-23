// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_login_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthenticationLoginPostRequest extends AuthenticationLoginPostRequest {
  @override
  final String? phoneNumber;
  @override
  final String? password;

  factory _$AuthenticationLoginPostRequest(
          [void Function(AuthenticationLoginPostRequestBuilder)? updates]) =>
      (new AuthenticationLoginPostRequestBuilder()..update(updates))._build();

  _$AuthenticationLoginPostRequest._({this.phoneNumber, this.password})
      : super._();

  @override
  AuthenticationLoginPostRequest rebuild(
          void Function(AuthenticationLoginPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthenticationLoginPostRequestBuilder toBuilder() =>
      new AuthenticationLoginPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthenticationLoginPostRequest &&
        phoneNumber == other.phoneNumber &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthenticationLoginPostRequest')
          ..add('phoneNumber', phoneNumber)
          ..add('password', password))
        .toString();
  }
}

class AuthenticationLoginPostRequestBuilder
    implements
        Builder<AuthenticationLoginPostRequest,
            AuthenticationLoginPostRequestBuilder> {
  _$AuthenticationLoginPostRequest? _$v;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  AuthenticationLoginPostRequestBuilder() {
    AuthenticationLoginPostRequest._defaults(this);
  }

  AuthenticationLoginPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phoneNumber = $v.phoneNumber;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthenticationLoginPostRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthenticationLoginPostRequest;
  }

  @override
  void update(void Function(AuthenticationLoginPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthenticationLoginPostRequest build() => _build();

  _$AuthenticationLoginPostRequest _build() {
    final _$result = _$v ??
        new _$AuthenticationLoginPostRequest._(
          phoneNumber: phoneNumber,
          password: password,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
