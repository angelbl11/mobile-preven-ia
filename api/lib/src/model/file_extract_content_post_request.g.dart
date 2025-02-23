// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_extract_content_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FileExtractContentPostRequest extends FileExtractContentPostRequest {
  @override
  final JsonObject? patientID;

  factory _$FileExtractContentPostRequest(
          [void Function(FileExtractContentPostRequestBuilder)? updates]) =>
      (new FileExtractContentPostRequestBuilder()..update(updates))._build();

  _$FileExtractContentPostRequest._({this.patientID}) : super._();

  @override
  FileExtractContentPostRequest rebuild(
          void Function(FileExtractContentPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FileExtractContentPostRequestBuilder toBuilder() =>
      new FileExtractContentPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FileExtractContentPostRequest &&
        patientID == other.patientID;
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
    return (newBuiltValueToStringHelper(r'FileExtractContentPostRequest')
          ..add('patientID', patientID))
        .toString();
  }
}

class FileExtractContentPostRequestBuilder
    implements
        Builder<FileExtractContentPostRequest,
            FileExtractContentPostRequestBuilder> {
  _$FileExtractContentPostRequest? _$v;

  JsonObject? _patientID;
  JsonObject? get patientID => _$this._patientID;
  set patientID(JsonObject? patientID) => _$this._patientID = patientID;

  FileExtractContentPostRequestBuilder() {
    FileExtractContentPostRequest._defaults(this);
  }

  FileExtractContentPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _patientID = $v.patientID;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FileExtractContentPostRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FileExtractContentPostRequest;
  }

  @override
  void update(void Function(FileExtractContentPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FileExtractContentPostRequest build() => _build();

  _$FileExtractContentPostRequest _build() {
    final _$result = _$v ??
        new _$FileExtractContentPostRequest._(
          patientID: patientID,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
