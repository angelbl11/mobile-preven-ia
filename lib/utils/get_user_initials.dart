import 'package:mobile_preven_ia_app/firebase/storage/classes/user_profile.dart';

String getUserInitials(UserProfile userProfile) {
  String initials = '';
  if (userProfile.name.isNotEmpty) {
    initials += userProfile.name[0];
  }
  if (userProfile.lastName.isNotEmpty) {
    initials += userProfile.lastName[0];
  }
  return initials;
}
