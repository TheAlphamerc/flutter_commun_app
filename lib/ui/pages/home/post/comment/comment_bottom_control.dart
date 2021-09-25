import 'package:flutter/material.dart';
import 'package:flutter_commun_app/model/post/action/e_post_action.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/ui/pages/home/post/post.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';

class CommentBottomControl extends StatelessWidget {
  /// Contains post data
  final PostModel model;

  /// Logged in user profile
  final ProfileModel myUser;

  /// `onPostAction` is a callback which trigger when user perform some action
  ///
  /// For ex. upVote, downVote, and share the post
  final OnPostAction onPostAction;
  const CommentBottomControl({
    Key? key,
    required this.model,
    required this.onPostAction,
    required this.myUser,
  }) : super(key: key);

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
                  color: isUpVote ? context.primaryColor : color, size: 15)
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
                  color: isdownVote ? context.primaryColor : color, size: 15)
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 2, bottom: 8),
      width: context.width,
      child: Row(
        children: [
          /// Vote icon
          _vote(context),
          const SizedBox(width: 10),

          /// Comments Icon
          // _icon(context, icon: MdiIcons.chatOutline, text: model.commentsCount),
          const CircleAvatar(
            radius: 5,
            backgroundColor: KColors.light_gray_2,
          ),
          const SizedBox(width: 10),
          Text(model.createdAt!.toCommentTime,
              style: TextStyles.bodyText14(context)),
        ],
      ),
    );
  }
}
