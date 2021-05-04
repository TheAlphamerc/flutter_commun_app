import 'dart:convert';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  factory SharedPreferenceHelper() {
    return _singleton;
  }
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  Future<void> saveUserProfile(ProfileModel user) async {
    return (await SharedPreferences.getInstance()).setString(
        UserPreferenceKey.UserProfile.toString(), json.encode(user.toJson()));
  }

  Future<ProfileModel> getUserProfile() async {
    final instance = await SharedPreferences.getInstance();
    final jsonString =
        instance.getString(UserPreferenceKey.UserProfile.toString());
    if (jsonString == null) return null;
    return ProfileModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>);
  }

  Future clearPreferenceValues() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

// ignore: constant_identifier_names
enum UserPreferenceKey { UserProfile, UserName }
