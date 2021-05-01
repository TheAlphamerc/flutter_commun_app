import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_model.g.dart';
part 'profile_model.freezed.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    String id,
    String name,
    String email,
    String username,
    String createdAt,
    String photoURL,
    String phoneNumber,
    String providerId,
    @Default(false) isVerified,
  }) = _ProfileModel;
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

extension ProfileModelHelper on ProfileModel {}
