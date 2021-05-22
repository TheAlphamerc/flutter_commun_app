import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/painter/circle_border_painter.dart';

class WhatsNewWidget extends StatelessWidget {
  const WhatsNewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset(Images.onBoardPicFour),
            ),
          ).pR(12),
          Text(
            "What's new?",
            style: TextStyles.subtitle16(context),
          )
        ],
      ),
    );
  }
}
