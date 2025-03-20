import 'dart:io';

import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/classes/user_profile.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@Riverpod(keepAlive: true)
class UserController extends _$UserController {
  @override
  Future<UserProfile?> build() async {
    return getUserProfile();
  }

  Future<UserProfile?> getUserProfile() async {
    final uid = ref.read(fireAuthControllerProvider).value?.user.uid;

    try {
      return ref.read(fireStorageRepositoryProvider).getUserProfile(uid!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserWeight(double newWeight) {
    final uid = ref.read(fireAuthControllerProvider).value?.user.uid;
    try {
      return ref
          .read(fireStorageRepositoryProvider)
          .updateUserWeight(uid ?? '', newWeight);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfilePicture(File profilePicture) {
    final uid = ref.read(fireAuthControllerProvider).value?.user.uid;
    try {
      return ref
          .read(fireStorageRepositoryProvider)
          .updateProfilePicture(uid ?? '', profilePicture);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMonitoringPreferences({
    required bool monitorLdl,
    required bool monitorGlucose,
    required bool monitorWeight,
  }) {
    final uid = ref.read(fireAuthControllerProvider).value?.user.uid;
    try {
      return ref
          .read(fireStorageRepositoryProvider)
          .updateMonitoringPreferences(
            uid ?? '',
            monitorLdl: monitorLdl,
            monitorGlucose: monitorGlucose,
            monitorWeight: monitorWeight,
          );
    } catch (e) {
      rethrow;
    }
  }
}
