// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_register_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthenticationRegisterPostRequest
    extends AuthenticationRegisterPostRequest {
  @override
  final JsonObject? phoneNumber;
  @override
  final JsonObject? password;
  @override
  final JsonObject? personalInfo;

  factory _$AuthenticationRegisterPostRequest(
          [void Function(AuthenticationRegisterPostRequestBuilder)? updates]) =>
      (new AuthenticationRegisterPostRequestBuilder()..update(updates))
          ._build();

  _$AuthenticationRegisterPostRequest._(
      {this.phoneNumber, this.password, this.personalInfo})
      : super._();

  @override
  AuthenticationRegisterPostRequest rebuild(
          void Function(AuthenticationRegisterPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthenticationRegisterPostRequestBuilder toBuilder() =>
      new AuthenticationRegisterPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthenticationRegisterPostRequest &&
        phoneNumber == other.phoneNumber &&
        password == other.password &&
        personalInfo == other.personalInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, personalInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthenticationRegisterPostRequest')
          ..add('phoneNumber', phoneNumber)
          ..add('password', password)
          ..add('personalInfo', personalInfo))
        .toString();
  }
}

class AuthenticationRegisterPostRequestBuilder
    implements
        Builder<AuthenticationRegisterPostRequest,
            AuthenticationRegisterPostRequestBuilder> {
  _$AuthenticationRegisterPostRequest? _$v;

  JsonObject? _phoneNumber;
  JsonObject? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(JsonObject? phoneNumber) => _$this._phoneNumber = phoneNumber;

  JsonObject? _password;
  JsonObject? get password => _$this._password;
  set password(JsonObject? password) => _$this._password = password;

  JsonObject? _personalInfo;
  JsonObject? get personalInfo => _$this._personalInfo;
  set personalInfo(JsonObject? personalInfo) =>
      _$this._personalInfo = personalInfo;

  AuthenticationRegisterPostRequestBuilder() {
    AuthenticationRegisterPostRequest._defaults(this);
  }

  AuthenticationRegisterPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phoneNumber = $v.phoneNumber;
      _password = $v.password;
      _personalInfo = $v.personalInfo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthenticationRegisterPostRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthenticationRegisterPostRequest;
  }

  @override
  void update(
      void Function(AuthenticationRegisterPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthenticationRegisterPostRequest build() => _build();

  _$AuthenticationRegisterPostRequest _build() {
    final _$result = _$v ??
        new _$AuthenticationRegisterPostRequest._(
          phoneNumber: phoneNumber,
          password: password,
          personalInfo: personalInfo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
