import 'package:buynuk/presentation/profile/domain/models/profile_model.dart';
import 'package:buynuk/presentation/profile/domain/repository/profile_repo.dart';

class ProfileService {
  final ProfileRepository profileRepository;

  ProfileService({required this.profileRepository});

  // -----------------------------------------------------------------------
  ///  get profile
  // -----------------------------------------------------------------------

  Future<UserProfile> getProfile() async {
    return await profileRepository.getProfile();
  }

  // -----------------------------------------------------------------------
  ///  Edit Profile
  // -----------------------------------------------------------------------

  Future<void> editProfile(UserProfile profile) async {
    return await profileRepository.editProfile(profile);
  }

  // -----------------------------------------------------------------------
  ///  Change Password
  // -----------------------------------------------------------------------

  Future<void> changePassword(String oldPassword, String newPassword) async {
    return await profileRepository.changePassword(oldPassword, newPassword);
  }

  // -----------------------------------------------------------------------
  ///  Logout
  // -----------------------------------------------------------------------

  Future<void> logout() async {
    return await profileRepository.logout();
  }
}
