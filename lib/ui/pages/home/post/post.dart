import 'package:flutter/material.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/post/action/e_post_action.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/ui/pages/home/post/detail/post_detail_page.dart';
import 'package:flutter_commun_app/ui/pages/home/post/widget/post_bottom_control.dart';
import 'package:flutter_commun_app/ui/pages/home/post/widget/post_header.dart';
import 'package:flutter_commun_app/ui/pages/home/post/widget/post_image.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/ui/widget/kit/custom_bottom_sheet.dart';

typedef OnPostAction = void Function(PostAction action, PostModel model);

class Post extends StatelessWidget {
  /// Contains post data
  final PostModel post;

  /// Logged in user profile
  final ProfileModel myUser;

  /// `onPostAction` is a callback which trigger when user perform some action
  ///
  /// For ex. upVote, downVote, and share the post
  final OnPostAction onPostAction;

  /// Detaermine spacing arounf post widget
  final EdgeInsetsGeometry margin;

  /// Determine the type of post
  final PostType type;

  const Post({
    Key key,
    this.type = PostType.post,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    @required this.post,
    @required this.onPostAction,
    @required this.myUser,
  }) : super(key: key);

  Widget _trailing(BuildContext context) {
    final bool isMyPost = myUser.id == post.createdBy;
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
                Navigator.pop(context);
              },
              title: "Share",
            ),
            PrimarySheetButton(
              icon: Icons.bookmark,
              onPressed: () {
                onPostAction(PostAction.favourite, post);
                Navigator.pop(context);
              },
              title: "Add to Favourite",
            ),

            /// Post can be edit or delete by post owner only
            if (isMyPost) ...[
              PrimarySheetButton(
                icon: Icons.edit,
                onPressed: () {
                  onPostAction(PostAction.edit, post);
                  Navigator.pop(context);
                },
                title: "Edit",
              ),
              PrimarySheetButton(
                icon: Icons.delete,
                onPressed: () {
                  onPostAction(PostAction.delete, post);
                  Navigator.pop(context);
                },
                title: "Delete",
                color: KColors.red,
              ),
            ]
          ],
        );
      },
    );
  }

  // ignore: avoid_void_async
  void onPostTap(BuildContext context) async {
    if (type == PostType.detail) {
      return;
    }
    final action =
        await context.navigate.push(PostDetailPage.getRoute(post.id));
    if (action != null && action is PostAction) {
      onPostAction(action, post);
    } else if (action != null && action is PostModel) {
      onPostAction(PostAction.modify, action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.onPrimary,
      margin: margin,
      // padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// User tile

          PostHeader(post: post, trailing: _trailing(context)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Post description
              Text(post.description ?? "").hP16,

              /// Post Images
              PostImages(list: post.images),
            ],
          ).ripple(() => onPostTap(context)),

          /// Post bottom controls
          if (type != PostType.reply)
            PostBottomControl(
              model: post,
              onPostAction: onPostAction,
              myUser: myUser,
              type: type,
            ),
        ],
      ),
    );
  }
}
