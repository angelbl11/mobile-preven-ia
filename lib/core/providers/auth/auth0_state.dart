import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth0_state.freezed.dart';

@freezed
class Auth0State with _$Auth0State {
  const factory Auth0State({
    required Auth0 auth0,
    Credentials? credentials,
    @Default(false) bool isLoading,
    String? error,
  }) = _Auth0State;
}
