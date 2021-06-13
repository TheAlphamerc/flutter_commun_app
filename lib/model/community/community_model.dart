import 'package:freezed_annotation/freezed_annotation.dart';
part 'community_model.g.dart';
part 'e_social_link_type.dart';
part 'e_user_role.dart';
part 'community_model.freezed.dart';

@freezed
abstract class SocialLink with _$SocialLink {
  const factory SocialLink({
    String id,
    String name,
    String type,
    String username,
    String url,
  }) = _SocialLink;
  factory SocialLink.fromJson(Map<String, dynamic> json) =>
      _$SocialLinkFromJson(json);
}

@freezed
abstract class CoverImage with _$CoverImage {
  const factory CoverImage({
    String id,
    String path,
    String updatedBy,
    String modifiedAt,
    String createdAt,
  }) = _CoverImage;
  factory CoverImage.fromJson(Map<String, dynamic> json) =>
      _$CoverImageFromJson(json);
}

@freezed
abstract class CommunityModel with _$CommunityModel {
  const factory CommunityModel({
    String id,
    String name,
    String avatar,
    @JsonSerializable(
      anyMap: true,
    )
        CoverImage coverImage,
    List<String> topics,
    String description,
    String modifiedAt,
    String createdAt,
    String createdBy,
    String myRole,
    List<SocialLink> socialLinks,
  }) = _CommunityModel;
  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);
}

extension CommunityModelHelper on CommunityModel {
  Map<String, dynamic> get getJson {
    final map = toJson();
    map.removeWhere((key, value) => key.contains("coverImage"));
    // map.putIfAbsent(
    //     "coverImage",
    //     () => {
    //           "id": coverImage.id,
    //           "path": coverImage.path,
    //           "updatedBy": coverImage.updatedBy,
    //           "createdAt": coverImage.createdAt,
    //           "modifiedAt": coverImage.modifiedAt
    //         });
    return map;
  }
}
