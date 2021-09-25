import 'package:flutter_commun_app/model/profile/profile_model.dart';

abstract class Session {
  ProfileModel? user;
  Future<void> saveUserProfile(ProfileModel user);
  Future<ProfileModel?> getUserProfile();
  Future clearSession();
}
