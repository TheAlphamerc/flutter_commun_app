import 'package:flutter/material.dart';
import 'package:flutter_commun_app/model/community/community_model.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';

class CommunityTile extends StatelessWidget {
  final CommunityModel model;
  final VoidCallback onJoinButtonPressed;
  const CommunityTile({Key key, this.model, this.onJoinButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isJoined = model.myRole != MemberRole.notDefine.encode();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: context.onPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircularImage().pR(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.name, style: TextStyles.headline16(context)),
              Text(
                "1000 Followers",
                style: TextStyles.bodyText14(context)
                    .copyWith(color: KColors.dark_gray),
              ),
            ],
          ).extended,
          Chip(
                  label: Text(isJoined ? "Joined" : "Join",
                      style: TextStyles.headline16(context).copyWith(
                          color: !isJoined
                              ? context.onPrimary
                              : context.primaryColor)),
                  backgroundColor:
                      isJoined ? KColors.light_gray : context.primaryColor)
              .ripple(onJoinButtonPressed, radius: 40)
        ],
      ),
    );
  }
}
