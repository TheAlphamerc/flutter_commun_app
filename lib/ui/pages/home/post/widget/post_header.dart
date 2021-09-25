import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  /// Widget to be displayed on tailing part of header tile
  final Widget? trailing;

  /// The tile's internal padding.

  ///Insets a [PostHeader]'s contents

  ///If null, EdgeInsets.only(left: 16, right: 16) is used.
  final EdgeInsetsGeometry contentPadding;

  /// Determine the type of post
  final PostType? type;

  ///If [isFeedPost] is set to `true`, the community info will be displayed on the post header
  ///
  ///If [isFeedPost] is set to `false`, the user info will be displayed  the post header
  final bool isFeedPost;

  const PostHeader({
    Key? key,
    required this.post,
    this.trailing,
    this.type,
    this.isFeedPost = false,
    this.contentPadding = const EdgeInsets.only(left: 16, right: 16),
  }) : super(key: key);

  String? get profileImage {
    if (isFeedPost) {
      return post.communityAvatar;
    } else if (post.user != null) {
      return post.user!.photoURL!;
    }
    return null;
  }

  String? get profileName {
    if (isFeedPost) {
      return post.communityName;
    } else if (post.user != null) {
      return post.user!.name!;
    }
    return "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircularImage(path: profileImage),
      contentPadding: contentPadding,
      title: Text(
        profileName!,
        style: TextStyles.headline15(context),
      ),
      subtitle: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: post.createdAt!.toPostTime,
                style: TextStyles.bodyText14(context).size(12)),
            if (type != PostType.reply && isFeedPost)
              TextSpan(
                text: " ${post.user?.name ?? "N/A"}",
                style: TextStyles.bodyText14(context).primary(context).size(12),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    //// TODO: Navigate to profile
                    Utility.cprint("Navigate to User Profile");
                  },
              ),
          ],
        ),
      ),
      trailing: trailing,
    );
  }
}
