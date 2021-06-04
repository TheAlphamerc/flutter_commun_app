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
    String articleUrl,
    @Default(0) int upVote,
    @Default(0) int downVote,
    @Default(0) shareCount,
    List<String> comments,
    List<String> images,
    List<String> videos,
    List<String> attachments,
    String modifiedAt,
    String createdAt,
  }) = _PostModel;
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

extension PostModelHelper on PostModel {
  int get vote {
    return upVote - downVote;
  }

  String get commentsCount {
    if (comments != null && comments.isNotEmpty) {
      return "${comments.length}";
    } else {
      return "";
    }
  }
}
