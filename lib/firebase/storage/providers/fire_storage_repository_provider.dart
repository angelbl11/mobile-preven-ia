import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_preven_ia_app/firebase/storage/fire_storage_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fire_storage_repository_provider.g.dart';

@riverpod

/// [FireStorageRepository] provider
FireStorageRepository fireStorageRepository(
  Ref ref,
) {
  return FireStorageRepository();
}
