import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    String id,
    String title,
    String description,
    String createdBy,
    List<String> images,
    List<String> videos,
    List<String> attachments,
    String articleUrl,
    String modifiedAt,
    String createdAt,
  }) = _PostModel;
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
