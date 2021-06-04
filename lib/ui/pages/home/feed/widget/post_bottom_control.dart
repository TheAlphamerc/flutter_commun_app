import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';

class PostBottomControl extends StatelessWidget {
  final PostModel model;
  const PostBottomControl({Key key, this.model}) : super(key: key);
  Widget _icon(BuildContext context, {IconData icon, String text}) {
    final Color color = context.theme.iconTheme.color;
    return Expanded(
      flex: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyles.subtitle14(context)
                  .copyWith(color: color, fontSize: 12),
            )
          ],
        ),
      ).ripple(() {}, radius: 30),
    );
  }

  Widget _vote(BuildContext context) {
    final Color color = context.theme.iconTheme.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          color: KColors.light_gray, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.arrow_upward_rounded),
          const SizedBox(width: 5),
          Text("${model.vote}",
              style: TextStyles.subtitle14(context).copyWith(color: color)),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_downward_rounded),
        ],
      ),
    );
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
          _vote(context),
          const Spacer(),
          _icon(context, icon: Icons.remove_red_eye_outlined, text: "1.2K"),
          _icon(context, icon: MdiIcons.chatOutline, text: model.commentsCount),
          _icon(context,
              icon: MdiIcons.shareOutline, text: "${model.shareCount ==0 ? "" : model.shareCount}"),
        ],
      ),
    );
  }
}
