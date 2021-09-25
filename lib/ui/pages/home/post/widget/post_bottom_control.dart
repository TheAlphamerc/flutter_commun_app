import 'package:flutter/material.dart';
import 'package:flutter_commun_app/model/post/action/e_post_action.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/ui/pages/home/post/detail/post_detail_page.dart';
import 'package:flutter_commun_app/ui/pages/home/post/post.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';

class PostBottomControl extends StatelessWidget {
  /// Contains post data
  final PostModel model;

  /// Logged in user profile
  final ProfileModel myUser;

  /// `onPostAction` is a callback which trigger when user perform some action
  ///
  /// For ex. upVote, downVote, and share the post
  final OnPostAction onPostAction;

  /// Determine the type of post
  final PostType? type;
  const PostBottomControl({
    Key? key,
    this.type,
    required this.model,
    required this.onPostAction,
    required this.myUser,
  }) : super(key: key);

  Widget _icon(BuildContext context,
      {required IconData icon,
      required String text,
      bool isColoredIcon = false,
      required VoidCallback onPressed}) {
    final Color color = context.theme.iconTheme.color!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            icon,
            size: 24,
            color: isColoredIcon ? context.primaryColor : color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyles.subtitle14(context)
                .copyWith(color: color, fontSize: 12),
          )
        ],
      ),
    ).ripple(onPressed, radius: 30);
  }

  Widget _vote(BuildContext context) {
    final Color color = context.theme.iconTheme.color!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          color: KColors.light_gray, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          /// upVote icon
          Icon(Icons.arrow_upward_rounded,
                  color: isUpVote ? context.primaryColor : color)
              .ripple(() {
            onPostAction(PostAction.upVote, model);
          }),
          const SizedBox(width: 5),

          /// Vote count
          Text("${model.vote}",
              style: TextStyles.subtitle14(context).copyWith(
                  color:
                      isUpVote || isdownVote ? context.primaryColor : color)),
          const SizedBox(width: 5),

          /// Downvote icon
          Icon(Icons.arrow_downward_rounded,
                  color: isdownVote ? context.primaryColor : color)
              .ripple(() {
            onPostAction(PostAction.downVote, model);
          }),
        ],
      ),
    );
  }

  /// Return true if loggedIn user already upVoted on post
  bool get isUpVote {
    return model.myVoteStatus(myUser.id!) == PostVoteStatus.upVote;
  }

  /// Return true if loggedIn user already downVoted on post
  bool get isdownVote {
    return model.myVoteStatus(myUser.id!) == PostVoteStatus.downVote;
  }

  Future openPostDetail(BuildContext context) async {
    if (type == PostType.detail) {
      return;
    }
    final action = await context.navigate.push(PostDetailPage.getRoute(
        model.id!,
        onPostAction: (PostAction action, PostModel model) {}));
    if (action != null && action is PostAction) {
      onPostAction(action, model);
    } else if (action != null && action is PostModel) {
      onPostAction(PostAction.modify, action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      width: context.width,
      child: Row(
        children: [
          /// Vote icon
          _vote(context),
          const Spacer(),

          /// Post views icon
          // TODO: Remove static post view count and add dynamic one
          // _icon(context, icon: Icons.remove_red_eye_outlined, text: "1.2K"),

          /// Comments Icon
          _icon(context,
              icon: MdiIcons.chatOutline,
              text: model.commentsCount,
              onPressed: () => openPostDetail(context)),

          /// Share Icon
          _icon(context,
              icon: MdiIcons.shareOutline,
              text: model.shareCount,
              onPressed: () {}),
        ],
      ),
    );
  }
}
