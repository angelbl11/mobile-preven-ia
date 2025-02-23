import 'package:pvi_api/pvi_api.dart';

/// AuthenticationRepository
class PviRepository {
  /// Constructor
  PviRepository({
    required this.pviApi,
  });

  final PviApi pviApi;

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    final body = AuthenticationLoginPostRequest((b) => b
      ..phoneNumber = phoneNumber
      ..password = password);
    await pviApi.getDefaultApi().authenticationLoginPost(body: body);
  }
}
