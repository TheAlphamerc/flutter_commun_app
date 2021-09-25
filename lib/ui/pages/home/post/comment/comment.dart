import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/post/detail/post_detail_cubit.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/post/action/e_post_action.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/ui/pages/home/post/comment/comment_bottom_control.dart';
import 'package:flutter_commun_app/ui/pages/home/post/detail/post_detail_page.dart';
import 'package:flutter_commun_app/ui/pages/home/post/widget/post_header.dart';
import 'package:flutter_commun_app/ui/pages/home/post/widget/post_image.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';
import 'package:flutter_commun_app/ui/widget/kit/custom_bottom_sheet.dart';

class Comment extends StatelessWidget {
  /// Contains post data
  final PostModel post;

  /// Logged in user profile
  final ProfileModel myUser;

  /// `onPostAction` is a callback which trigger when user perform some action
  ///
  /// For ex. upVote, downVote, and share the post

  /// Detaermine spacing arounf post widget
  final EdgeInsetsGeometry margin;

  /// Determine the type of post
  final PostType type;

  const Comment({
    Key? key,
    this.type = PostType.post,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    required this.post,
    required this.myUser,
  }) : super(key: key);

  Widget _trailing(BuildContext context) {
    final bool isMyPost = myUser.id == post.createdBy;
    return IconButton(
      icon: Icon(
        Icons.more_vert,
        color: context.theme.iconTheme.color,
      ),
      alignment: Alignment.topCenter,
      onPressed: () {
        FocusManager.instance.primaryFocus!.unfocus();
        sheet.displayBottomSheet(
          context,
          headerChild: PostHeader(
            post: post,
            contentPadding: EdgeInsets.zero,
            type: type,
          ),
          sheetButton: [
            if (!isMyPost)
              PrimarySheetButton(
                icon: Icons.warning_amber_rounded,
                onPressed: () {
                  context.read<PostDetailCubit>().reportPost(post);
                  Navigator.pop(context);
                },
                title: context.locale.report,
              ),

            /// Comment can be edit or delete by post owner only
            if (isMyPost) ...[
              PrimarySheetButton(
                icon: Icons.edit,
                onPressed: () {
                  // onPostAction(PostAction.edit, post);
                  Navigator.pop(context);
                },
                title: context.locale.edit,
              ),
              PrimarySheetButton(
                icon: Icons.delete,
                onPressed: () {
                  // onPostAction(PostAction.delete, post);
                  context.read<PostDetailCubit>().deletePost(post);
                  Navigator.pop(context);
                },
                title: context.locale.delete,
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
    final action = await context.navigate.push(PostDetailPage.getRoute(post.id!,
        onPostAction: (PostAction action, PostModel model) {}));
    if (action != null && action is PostAction) {
      // onPostAction(action, post);
    } else if (action != null && action is PostModel) {
      // onPostAction(PostAction.modify, action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.onPrimary,
      margin: margin,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0,
        minLeadingWidth: 50,
        isThreeLine: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircularImage().hP8,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                  color: KColors.light_gray,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Posted by ",
                            style: TextStyles.headline16(context)),
                        TextSpan(
                            text: post.description,
                            style: TextStyles.bodyText15(context)),
                      ],
                    ),
                  ),

                  /// Post Images
                  PostImages(list: post.images!),
                ],
              ),
            ).extended,
            _trailing(context),
          ],
        ),
        subtitle: CommentBottomControl(
          model: post,
          myUser: myUser,
          onPostAction: (PostAction action, PostModel model) {},
        ).pL(40),
      ),
    );
  }
}
