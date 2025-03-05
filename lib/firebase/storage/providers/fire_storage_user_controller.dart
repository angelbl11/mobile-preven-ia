import 'package:mobile_preven_ia_app/firebase/auth/providers/fire_auth_controller.dart';
import 'package:mobile_preven_ia_app/firebase/storage/classes/user_profile.dart';
import 'package:mobile_preven_ia_app/firebase/storage/providers/fire_storage_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fire_storage_user_controller.g.dart';

@Riverpod(keepAlive: true)
class FireStorageUserController extends _$FireStorageUserController {
  @override
  Future<UserProfile?> build() async {
    return getUserProfile();
  }

  Future<UserProfile?> getUserProfile() async {
    final uid = ref.read(fireAuthControllerProvider).value?.user.uid;
    print('uid: $uid');
    final userProfile =
        await ref.read(fireStorageRepositoryProvider).getUserProfile(uid ?? '');
    return userProfile;
  }
}
