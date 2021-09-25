import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_model.g.dart';
part 'profile_model.freezed.dart';
part 'e_profile_provider_id.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    String? id,
    String? name,
    String? email,
    String? username,
    String? createdAt,
    String? photoURL,
    String? phoneNumber,
    String? website,
    String? bio,
    String? bannerURL,
    String? providerId,
    @Default(false) isVerified,
  }) = _ProfileModel;
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

extension ProfileModelHelper on ProfileModel {
  /// Returns enum value of  `EProfileProviderId` on the basis of `providerId`
  EProfileProviderId get eProviderId =>
      EProfileProviderId.Google.key(providerId);
}
