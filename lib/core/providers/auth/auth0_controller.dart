import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:mobile_preven_ia_app/core/classes/environment_keys.dart';
import 'package:mobile_preven_ia_app/core/providers/auth/auth0_state.dart';
import 'package:mobile_preven_ia_app/core/providers/network/custom_dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer' as developer;

part 'auth0_controller.g.dart';

@Riverpod(keepAlive: true)
class Auth0Controller extends _$Auth0Controller {
  @override
  Auth0State build() {
    final auth0 = Auth0(
      EnvironmentKeys.auth0Domain,
      EnvironmentKeys.auth0ClientId,
    );

    // Check for existing credentials on initialization
    _checkExistingCredentials(auth0);

    return Auth0State(
      auth0: auth0,
    );
  }

  Future<void> _checkExistingCredentials(Auth0 auth0) async {
    try {
      developer.log('Checking for existing credentials...');
      final credentials = await auth0.credentialsManager.credentials();

      if (credentials.accessToken.isNotEmpty) {
        developer.log('Found existing credentials, updating state...');
        state = state.copyWith(
          credentials: credentials,
          isLoading: false,
          error: null,
        );
        ref.read(customDioControllerProvider).updateToken(credentials.idToken);
      } else {
        developer.log('No valid credentials found');
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      developer.log('Error checking credentials: $e');
      // Ignore errors when checking credentials
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    }
  }

  /// Login
  Future<Credentials> login() async {
    try {
      state = state.copyWith(isLoading: true);

      final credentials = await state.auth0
          .webAuthentication(scheme: 'com.mobile.preven.ia.app')
          .login(
        scopes: {'openid', 'profile', 'email', 'offline_access'},
        parameters: {
          'screen_hint': 'login',
          'prompt': 'login',
        },
      );

      developer.log('Login successful, storing credentials...');
      // Store credentials in secure storage
      await state.auth0.credentialsManager.storeCredentials(credentials);

      state = state.copyWith(
        credentials: credentials,
        isLoading: false,
        error: null,
      );

      ref.read(customDioControllerProvider).updateToken(credentials.idToken);

      return credentials;
    } catch (e) {
      developer.log('Login error: $e');
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

      final credentials = await state.auth0
          .webAuthentication(scheme: 'com.mobile.preven.ia.app')
          .login(
        scopes: {'openid', 'profile', 'email', 'offline_access'},
        parameters: {
          'screen_hint': 'signup',
          'prompt': 'login',
        },
      );

      developer.log('Registration successful, storing credentials...');
      // Store credentials in secure storage
      await state.auth0.credentialsManager.storeCredentials(credentials);

      state = state.copyWith(
        credentials: credentials,
        isLoading: false,
        error: null,
      );

      ref.read(customDioControllerProvider).updateToken(credentials.idToken);

      return credentials;
    } catch (e) {
      developer.log('Registration error: $e');
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

      // Clear credentials from secure storage
      await state.auth0.credentialsManager.clearCredentials();

      await state.auth0
          .webAuthentication(scheme: 'com.mobile.preven.ia.app')
          .logout();

      // Clear the HTTP client token
      ref.read(customDioControllerProvider).updateToken('');

      // Clear the state without opening the web browser
      state = state.copyWith(
        credentials: null,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      developer.log('Logout error: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      throw Exception('Error during logout: $e');
    }
  }
}
