import 'dart:convert';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/session/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionImpl implements Session {
  @override
  ProfileModel? user;

  @override
  Future<void> saveUserProfile(ProfileModel model) async {
    user = model;
    (await SharedPreferences.getInstance()).setString(
        UserPreferenceKey.userProfile.toString(), json.encode(user!.toJson()));
  }

  @override
  Future<ProfileModel?> getUserProfile() async {
    final instance = await SharedPreferences.getInstance();
    final jsonString =
        instance.getString(UserPreferenceKey.userProfile.toString());
    if (jsonString == null) return null;
    // ignore: join_return_with_assignment
    user =
        ProfileModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
    return user!;
  }

  @override
  Future clearSession() async {
    final pref = await SharedPreferences.getInstance();
    user = null;
    pref.clear();
  }
}

enum UserPreferenceKey { userProfile }
