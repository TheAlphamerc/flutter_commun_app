import 'package:flutter/material.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  /// Widget to be displayed on tailing part of header tile
  final Widget trailing;

  /// The tile's internal padding.

  ///Insets a [PostHeader]'s contents

  ///If null, EdgeInsets.only(left: 16, right: 16) is used.
  final EdgeInsetsGeometry contentPadding;

  /// Determine the type of post
  final PostType type;

  const PostHeader(
      {Key key,
      this.post,
      this.trailing,
      this.contentPadding = const EdgeInsets.only(left: 16, right: 16),
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /// TODO: Use useravatar in case of Comments
      leading: CircularImage(path: post.communityAvatar),
      contentPadding: contentPadding,
      title: Text(post.communityName ?? "Posted by",
          style: TextStyles.headline15(context)),
      subtitle: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: post.createdAt.toPostTime,
              style: TextStyles.bodyText14(context).size(12)),
          if (type != PostType.reply)
            TextSpan(
                text: " Posted by",
                style:
                    TextStyles.bodyText14(context).primary(context).size(12)),
        ]),
      ),
      trailing: trailing,
    );
  }
}
