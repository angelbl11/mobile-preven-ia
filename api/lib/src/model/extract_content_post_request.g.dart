// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extract_content_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExtractContentPostRequest extends ExtractContentPostRequest {
  @override
  final JsonObject? patientID;

  factory _$ExtractContentPostRequest(
          [void Function(ExtractContentPostRequestBuilder)? updates]) =>
      (new ExtractContentPostRequestBuilder()..update(updates))._build();

  _$ExtractContentPostRequest._({this.patientID}) : super._();

  @override
  ExtractContentPostRequest rebuild(
          void Function(ExtractContentPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExtractContentPostRequestBuilder toBuilder() =>
      new ExtractContentPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExtractContentPostRequest && patientID == other.patientID;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, patientID.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExtractContentPostRequest')
          ..add('patientID', patientID))
        .toString();
  }
}

class ExtractContentPostRequestBuilder
    implements
        Builder<ExtractContentPostRequest, ExtractContentPostRequestBuilder> {
  _$ExtractContentPostRequest? _$v;

  JsonObject? _patientID;
  JsonObject? get patientID => _$this._patientID;
  set patientID(JsonObject? patientID) => _$this._patientID = patientID;

  ExtractContentPostRequestBuilder() {
    ExtractContentPostRequest._defaults(this);
  }

  ExtractContentPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _patientID = $v.patientID;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExtractContentPostRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ExtractContentPostRequest;
  }

  @override
  void update(void Function(ExtractContentPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExtractContentPostRequest build() => _build();

  _$ExtractContentPostRequest _build() {
    final _$result = _$v ??
        new _$ExtractContentPostRequest._(
          patientID: patientID,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
