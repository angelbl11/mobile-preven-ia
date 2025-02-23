// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterPostRequest extends RegisterPostRequest {
  @override
  final JsonObject? phoneNumber;
  @override
  final JsonObject? password;
  @override
  final JsonObject? personalInfo;

  factory _$RegisterPostRequest(
          [void Function(RegisterPostRequestBuilder)? updates]) =>
      (new RegisterPostRequestBuilder()..update(updates))._build();

  _$RegisterPostRequest._({this.phoneNumber, this.password, this.personalInfo})
      : super._();

  @override
  RegisterPostRequest rebuild(
          void Function(RegisterPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterPostRequestBuilder toBuilder() =>
      new RegisterPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterPostRequest &&
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
    return (newBuiltValueToStringHelper(r'RegisterPostRequest')
          ..add('phoneNumber', phoneNumber)
          ..add('password', password)
          ..add('personalInfo', personalInfo))
        .toString();
  }
}

class RegisterPostRequestBuilder
    implements Builder<RegisterPostRequest, RegisterPostRequestBuilder> {
  _$RegisterPostRequest? _$v;

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

  RegisterPostRequestBuilder() {
    RegisterPostRequest._defaults(this);
  }

  RegisterPostRequestBuilder get _$this {
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
  void replace(RegisterPostRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RegisterPostRequest;
  }

  @override
  void update(void Function(RegisterPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterPostRequest build() => _build();

  _$RegisterPostRequest _build() {
    final _$result = _$v ??
        new _$RegisterPostRequest._(
          phoneNumber: phoneNumber,
          password: password,
          personalInfo: personalInfo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
