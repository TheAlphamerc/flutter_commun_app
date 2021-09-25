import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/painter/circle_border_painter.dart';

class CircularImage extends StatelessWidget {
  final String? path;
  final double stroke;
  final Color strokeColor;
  final double height;
  const CircularImage({
    Key? key,
    this.path,
    this.strokeColor = KColors.light_gray,
    this.stroke = 1,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircleBorderPainter(color: strokeColor, stroke: stroke),
      child: SizedBox(
        height: height,
        width: height,
        child: path != null && !path!.contains("object-not-found")
            ? CircleAvatar(
                radius: 20,
                key: const ValueKey("user-profile"),
                backgroundColor: KColors.light_gray,
                backgroundImage: NetworkImage(path!),
              )
            : Image.asset(Images.defaultUser),
      ),
    );
  }
}
