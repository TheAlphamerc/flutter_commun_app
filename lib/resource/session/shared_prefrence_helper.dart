import 'dart:convert';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() {
    return _singleton;
  }

  Future<void> saveUserProfile(ProfileModel user) async {
    return (await SharedPreferences.getInstance()).setString(
        UserPreferenceKey.UserProfile.toString(), json.encode(user.toJson()));
  }

  Future<ProfileModel> getUserProfile() async {
    var instance = await SharedPreferences.getInstance();
    final jsonString =
        instance.getString(UserPreferenceKey.UserProfile.toString());
    if (jsonString == null) return null;
    return ProfileModel.fromJson(json.decode(jsonString));
  }

  Future clearPreferenceValues() async {
    await (SharedPreferences.getInstance())
      ..clear();
  }
}

enum UserPreferenceKey {
  UserProfile,
  UserName,
}
