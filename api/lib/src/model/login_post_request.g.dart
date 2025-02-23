// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginPostRequest extends LoginPostRequest {
  @override
  final JsonObject? phoneNumber;
  @override
  final JsonObject? password;

  factory _$LoginPostRequest(
          [void Function(LoginPostRequestBuilder)? updates]) =>
      (new LoginPostRequestBuilder()..update(updates))._build();

  _$LoginPostRequest._({this.phoneNumber, this.password}) : super._();

  @override
  LoginPostRequest rebuild(void Function(LoginPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginPostRequestBuilder toBuilder() =>
      new LoginPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginPostRequest &&
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
    return (newBuiltValueToStringHelper(r'LoginPostRequest')
          ..add('phoneNumber', phoneNumber)
          ..add('password', password))
        .toString();
  }
}

class LoginPostRequestBuilder
    implements Builder<LoginPostRequest, LoginPostRequestBuilder> {
  _$LoginPostRequest? _$v;

  JsonObject? _phoneNumber;
  JsonObject? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(JsonObject? phoneNumber) => _$this._phoneNumber = phoneNumber;

  JsonObject? _password;
  JsonObject? get password => _$this._password;
  set password(JsonObject? password) => _$this._password = password;

  LoginPostRequestBuilder() {
    LoginPostRequest._defaults(this);
  }

  LoginPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phoneNumber = $v.phoneNumber;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginPostRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$LoginPostRequest;
  }

  @override
  void update(void Function(LoginPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginPostRequest build() => _build();

  _$LoginPostRequest _build() {
    final _$result = _$v ??
        new _$LoginPostRequest._(
          phoneNumber: phoneNumber,
          password: password,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
