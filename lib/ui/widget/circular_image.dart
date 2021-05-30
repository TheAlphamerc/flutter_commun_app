import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/painter/circle_border_painter.dart';

class CircularImage extends StatelessWidget {
  final String path;
  const CircularImage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircleBorderPainter(color: context.disabledColor),
      child: SizedBox(
        height: 40,
        width: 40,
        child: path != null
            ? CircleAvatar(
                radius: 20,
                key: const ValueKey("user-profile"),
                backgroundColor: KColors.light_gray,
                backgroundImage: NetworkImage(path),
              )
            : Image.asset(Images.onBoardPicFour),
      ),
    );
  }
}
