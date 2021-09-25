import 'dart:convert';

import 'package:flutter_commun_app/model/community/cover_image_model.dart';
import 'package:flutter_commun_app/model/community/social_link_model.dart';

part 'e_social_link_type.dart';
part 'e_user_role.dart';
// part 'community_model.g.dart';
// part 'community_model.freezed.dart';

// @freezed
// abstract class CommunityModel with _$CommunityModel {
//   const factory CommunityModel({
//     String id,
//     String name,
//     String avatar,
//     String banner,
//     CoverImage coverImage,
//     List<String> topics,
//     String description,
//     String modifiedAt,
//     String createdAt,
//     String createdBy,
//     String myRole,
//     List<SocialLinkModel> socialLinks,
//   }) = _CommunityModel;
//   factory CommunityModel.fromJson(Map<String, dynamic> json) =>
//       _$CommunityModelFromJson(json);
// }

// extension CommunityModelHelper on CommunityModel {
//   Map<String, dynamic> get getJson {
//     final map = toJson();
//     map.removeWhere((key, value) => key.contains("coverImage"));
//     // map.putIfAbsent(
//     //     "coverImage",
//     //     () => {
//     //           "id": coverImage.id,
//     //           "path": coverImage.path,
//     //           "updatedBy": coverImage.updatedBy,
//     //           "createdAt": coverImage.createdAt,
//     //           "modifiedAt": coverImage.modifiedAt
//     //         });
//     return map;
//   }
// }

class Topic {
  final String? id;
  final String? name;

  Topic({this.id, this.name});
}

class CommunityModel {
  CommunityModel(
      {this.id,
      this.name,
      this.avatar,
      this.banner,
      this.topics,
      this.description,
      this.socialLinks,
      this.coverImage,
      this.modifyAt,
      this.createdAt,
      this.myRole,
      this.createdBy,
      this.membersCount = 0});

  final String? id;
  final String? name;
  final String? avatar;
  final String? banner;
  final List<String>? topics;
  final String? description;
  final String? modifyAt;
  final String? createdAt;
  final String? myRole;
  final String? createdBy;
  final int? membersCount;
  final List<SocialLinkModel>? socialLinks;
  final List<CoverImage>? coverImage;

  CommunityModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? banner,
    List<String>? topics,
    String? description,
    List<SocialLinkModel>? socialLinks,
    List<CoverImage>? coverImage,
    String? modifyAt,
    int? membersCount,
    String? myRole,
    String? createdAt,
    String? createdBy,
  }) =>
      CommunityModel(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        banner: banner ?? this.banner,
        topics: topics ?? this.topics,
        description: description ?? this.description,
        socialLinks: socialLinks ?? this.socialLinks,
        coverImage: coverImage ?? this.coverImage,
        modifyAt: modifyAt ?? this.modifyAt,
        membersCount: membersCount ?? this.membersCount,
        createdAt: createdAt ?? this.createdAt,
        myRole: myRole ?? this.myRole,
        createdBy: createdBy ?? this.createdBy,
      );

  factory CommunityModel.fromRawJson(String str) =>
      CommunityModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        banner: json["banner"],
        topics: json["topics"] == null
            ? null
            : List<String>.from(json["topics"].map((x) => x)),
        // ignore: unnecessary_null_in_if_null_operators
        socialLinks: json["socialLinks"] == null
            ? null
            : List<SocialLinkModel>.from(
                json["socialLinks"].map((x) => SocialLinkModel.fromJson(x))),
        coverImage: json["coverImage"] == null
            ? null
            : List<CoverImage>.from(
                json["coverImage"].map((e) => CoverImage.fromJson(e))),
        description: json["description"],
        membersCount: json["membersCount"] ?? 0,
        modifyAt: json["modifyAt"],
        createdAt: json["createdAt"],
        myRole: json["myRole"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "avatar": avatar,
      "banner": banner,
      "topics":
          topics == null ? null : List<dynamic>.from(topics!.map((x) => x)),
      "socialLinks": socialLinks == null
          ? null
          : List<dynamic>.from(socialLinks!.map((e) => e.toJson())),
      "coverImage": coverImage == null
          ? null
          : List<dynamic>.from(coverImage!.map((x) => x.toJson())),
      "description": description,
      "modifyAt": modifyAt,
      "membersCount": membersCount,
      "createdAt": createdAt,
      "myRole": myRole,
      "createdBy": createdBy,
    };
  }
}
