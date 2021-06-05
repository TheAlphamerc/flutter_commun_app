import 'package:flutter/material.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/post/action/e_post_action.dart';
import 'package:flutter_commun_app/ui/pages/home/feed/widget/post_bottom_control.dart';
import 'package:flutter_commun_app/ui/pages/home/feed/widget/post_header.dart';
import 'package:flutter_commun_app/ui/pages/home/feed/widget/post_image.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/ui/widget/kit/custom_bottom_sheet.dart';

typedef OnPostAction = void Function(PostAction action, PostModel model);

class Post extends StatelessWidget {
  final PostModel post;
  final OnPostAction onPostAction;
  const Post({Key key, this.post, @required this.onPostAction})
      : super(key: key);

  Widget _trailing(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.more_vert,
        color: context.theme.iconTheme.color,
      ),
      onPressed: () {
        sheet.displayBottomSheet(
          context,
          headerChild: PostHeader(post: post, contentPadding: EdgeInsets.zero),
          sheetButton: [
            PrimarySheetButton(
              icon: MdiIcons.shareAll,
              onPressed: () {
                onPostAction(PostAction.share, post);
              },
              title: "Share",
            ),
            PrimarySheetButton(
              icon: Icons.bookmark,
              onPressed: () {
                onPostAction(PostAction.favourite, post);
              },
              title: "Add to Favourite",
            ),
            PrimarySheetButton(
              icon: Icons.edit,
              onPressed: () {
                onPostAction(PostAction.edit, post);
              },
              title: "Edit",
            ),
            PrimarySheetButton(
              icon: Icons.delete,
              onPressed: () {
                onPostAction(PostAction.delete, post);
              },
              title: "Delete",
              color: KColors.red,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.onPrimary,
      margin: const EdgeInsets.symmetric(vertical: 8),
      // padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// User tile

          PostHeader(
            post: post,
            trailing: _trailing(context),
          ),

          /// Post description
          Text(post.description ?? "").hP16,

          /// Post Images
          PostImages(list: post.images),

          /// Post bottom controls
          PostBottomControl(model: post, onPostAction: onPostAction),
        ],
      ),
    );
  }
}
