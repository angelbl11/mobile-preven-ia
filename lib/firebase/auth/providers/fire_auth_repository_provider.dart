import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/auth/fire_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fire_auth_repository_provider.g.dart';

@riverpod

/// [FireAuthRepository] provider
FireAuthRepository fireAuthRepository(
  Ref ref,
) {
  return FireAuthRepository();
}
