import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:mobile_preven_ia_app/core/classes/environment_keys.dart';
import 'package:mobile_preven_ia_app/core/providers/auth/auth0_state.dart';
import 'package:mobile_preven_ia_app/core/providers/network/custom_dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth0_controller.g.dart';

@Riverpod(keepAlive: true)
class Auth0Controller extends _$Auth0Controller {
  @override
  Auth0State build() {
    return Auth0State(
      auth0: Auth0(
        EnvironmentKeys.auth0Domain,
        EnvironmentKeys.auth0ClientId,
      ),
    );
  }

  /// Login
  Future<Credentials> login() async {
    try {
      state = state.copyWith(isLoading: true);

      final credentials = await state.auth0.webAuthentication().login(
        scopes: {'openid', 'profile', 'email', 'offline_access'},
        parameters: {'screen_hint': 'login'},
      );

      state = state.copyWith(
        credentials: credentials,
        isLoading: false,
        error: null,
      );

      print('TOKEN: ${credentials.idToken}');

      ref.read(customDioControllerProvider).updateToken(credentials.idToken);

      return credentials;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      throw Exception('Error during login: $e');
    }
  }

  /// Register
  Future<Credentials> register() async {
    try {
      state = state.copyWith(isLoading: true);

      final credentials = await state.auth0.webAuthentication().login(
        scopes: {'openid', 'profile', 'email', 'offline_access'},
        parameters: {'screen_hint': 'signup'},
      );

      state = state.copyWith(
        credentials: credentials,
        isLoading: false,
        error: null,
      );

      ref.read(customDioControllerProvider).updateToken(credentials.idToken);

      return credentials;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      throw Exception('Error during register: $e');
    }
  }

  String? get accessToken => state.credentials?.accessToken;
  String? get idToken => state.credentials?.idToken;
  bool get isAuthenticated => state.credentials != null;
  bool get isLoading => state.isLoading;
  String? get error => state.error;

  /// Logout
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);

      await state.auth0.webAuthentication(scheme: 'https').logout();

      state = state.copyWith(
        credentials: null,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      throw Exception('Error during logout: $e');
    }
  }
}
