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
export 'package:flutter_commun_app/model/post/action/e_post_action.dart';

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
  final PostType? type;

  ///If [isFeedPost] is set to `true`, the community info will be displayed on the post header
  ///
  ///If [isFeedPost] is set to `false`, the user info will be displayed  the post header
  final bool isFeedPost;

  const Post({
    Key? key,
    this.type = PostType.post,
    required this.post,
    required this.onPostAction,
    required this.myUser,
    this.isFeedPost = false,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
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
          headerChild: PostHeader(
            post: post,
            type: type!,
            contentPadding: EdgeInsets.zero,
            isFeedPost: isFeedPost,
          ),
          sheetButton: [
            PrimarySheetButton(
              icon: MdiIcons.shareAllOutline,
              onPressed: () {
                onPostAction(PostAction.share, post);
                Navigator.pop(context);
              },
              title: context.locale.share,
            ),
            PrimarySheetButton(
              icon: Icons.bookmark_border_rounded,
              onPressed: () {
                onPostAction(PostAction.favourite, post);
                Navigator.pop(context);
              },
              title: context.locale.add_to_favourite,
            ),

            /// Post can be edit or delete by post owner only
            if (isMyPost) ...[
              PrimarySheetButton(
                icon: Icons.edit,
                onPressed: () {
                  onPostAction(PostAction.edit, post);
                  Navigator.pop(context);
                },
                title: context.locale.edit,
              ),
              PrimarySheetButton(
                icon: Icons.delete,
                onPressed: () {
                  Navigator.pop(context);
                  onPostAction(PostAction.delete, post);
                },
                title: context.locale.delete,
                color: KColors.red,
              ),
            ],
            if (!isMyPost)
              PrimarySheetButton(
                icon: Icons.warning_amber_rounded,
                onPressed: () {
                  onPostAction(PostAction.report, post);
                  Navigator.pop(context);
                },
                title: context.locale.report,
              ),
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
    final action = await context.navigate.push(PostDetailPage.getRoute(
      post.id!,
      onPostAction: (PostAction action, PostModel model) {},
    ));
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
          PostHeader(
            post: post,
            trailing: _trailing(context),
            isFeedPost: isFeedPost,
          ),

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
