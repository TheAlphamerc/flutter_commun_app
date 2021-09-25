import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_model.freezed.dart';
part 'post_model.g.dart';
part 'e_post_type.dart';
part 'e_attachment_type.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    String? id,
    String? title,
    String? description,
    String? createdBy,
    String? articleUrl,
    String? parentPostId,
    List<String>? comments,
    List<String>? images,
    List<String>? videos,
    List<String>? shareList,
    List<String>? upVotes,
    List<String>? downVotes,
    List<String>? attachments,
    String? modifiedAt,
    String? createdAt,
    String? communityId,
    String? communityName,
    String? communityAvatar,
    ProfileModel? user,
  }) = _PostModel;
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

extension PostModelHelper on PostModel {
  int get vote {
    if (upVotes != null && downVotes != null) {
      return upVotes!.length - downVotes!.length;
    }
    if (upVotes != null) {
      return upVotes!.length;
    }
    if (downVotes != null) {
      return downVotes!.length;
    }
    return 0;
  }

  String get commentsCount {
    if (comments != null && comments!.isNotEmpty) {
      return "${comments!.length}";
    } else {
      return "";
    }
  }

  String get shareCount {
    if (shareList != null && shareList!.isNotEmpty) {
      return "${shareList!.length}";
    } else {
      return "";
    }
  }

  PostVoteStatus myVoteStatus(String myuserId) {
    if (upVotes != null && upVotes!.isNotEmpty && upVotes!.contains(myuserId)) {
      return PostVoteStatus.upVote;
    } else if (downVotes != null &&
        downVotes!.isNotEmpty &&
        downVotes!.contains(myuserId)) {
      return PostVoteStatus.downVote;
    } else {
      return PostVoteStatus.noVote;
    }
  }
}

enum PostVoteStatus { upVote, downVote, noVote }
