import 'package:flutter/material.dart';
import 'package:flutter_commun_app/cubit/app/app_cubit.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/ui/pages/post/create_post_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/ui/widget/painter/circle_border_painter.dart';

class WhatsNewWidget extends StatelessWidget {
  const WhatsNewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppCubit>().user;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      color: context.onPrimary,
      child: Row(
        children: [
          CustomPaint(
            painter: CircleBorderPainter(color: context.disabledColor),
            child: SizedBox(
              height: 40,
              width: 40,
              child: user.photoURL != null
                  ? CircleAvatar(
                      radius: 20,
                      key: const ValueKey("user-profile"),
                      backgroundColor: KColors.light_gray,
                      backgroundImage: NetworkImage(user.photoURL),
                    )
                  : Image.asset(Images.onBoardPicFour),
            ),
          ).pR(12),
          Text(
            "What's new?",
            style: TextStyles.subtitle16(context),
          )
        ],
      ),
    ).ripple(() {
      Navigator.push(context, CreatePostPage.getRoute());
    });
  }
}
