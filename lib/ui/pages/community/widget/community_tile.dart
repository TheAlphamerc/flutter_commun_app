import 'package:flutter/material.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/ui/pages/community/detail/community_profile_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';

class CommunityTile extends StatelessWidget {
  final CommunityModel model;
  final VoidCallback? onJoinButtonPressed;
  final VoidCallback? onTilePressed;
  const CommunityTile(
      {Key? key,
      required this.model,
      this.onJoinButtonPressed,
      this.onTilePressed})
      : super(key: key);

  int get membersCount {
    if (model.membersCount == null || model.membersCount == -1) return 0;
    return model.membersCount!;
  }

  Widget _rippleWrapper(BuildContext context, Widget child) {
    if (onJoinButtonPressed == null && onTilePressed != null) {
      return child.ripple(onTilePressed!);
    } else {
      return child;
    }
  }

  Widget _tile(BuildContext context) {
    final bool isJoined = model.myRole != MemberRole.notDefine.encode();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: context.onPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircularImage(
            path: model.avatar,
          ).pR(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.name!, style: TextStyles.headline16(context)),
              Text(
                "$membersCount Followers",
                style: TextStyles.bodyText14(context)
                    .copyWith(color: KColors.dark_gray),
              ),
            ],
          ).ripple(() {
            Navigator.push(
              context,
              CommunityProfilePage.getRoute(
                  community: model, communityId: model.id),
            );
          }).extended,
          if (onJoinButtonPressed != null)
            Chip(
                    label: Text(isJoined ? "Joined" : "Join",
                        style: TextStyles.headline16(context).copyWith(
                            color: !isJoined
                                ? context.onPrimary
                                : context.primaryColor)),
                    backgroundColor:
                        isJoined ? KColors.light_gray : context.primaryColor)
                .ripple(onJoinButtonPressed!, radius: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _rippleWrapper(context, _tile(context));
  }
}
