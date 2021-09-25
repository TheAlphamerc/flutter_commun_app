import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class TileActionWidget extends StatelessWidget {
  const TileActionWidget({
    Key? key,
    this.icon,
    this.list = const [],
    this.menuKey,
    this.iconColor,
  }) : super(key: key);
  final Widget? icon;
  final Color? iconColor;
  final List<Choice>? list;
  final GlobalKey? menuKey;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      key: menuKey,
      onSelected: (action) {
        if (action.onPressed != null) {
          action.onPressed!.call();
        }
      },
      padding: EdgeInsets.zero,
      color: context.onPrimary,
      icon: icon ??
          Icon(
            Icons.more_vert,
            color: context.theme.iconTheme.color,
          ),
      itemBuilder: (BuildContext context) {
        return list!.map((Choice choice) {
          return PopupMenuItem<Choice>(
              value: choice,
              child: Row(
                children: [
                  Icon(
                    choice.icon,
                    size: 20,
                    color: Theme.of(context).iconTheme.color,
                  ).pR(8),
                  Text(
                    choice.title,
                    style: TextStyles.bodyText15(context),
                  ),
                ],
              ));
        }).toList();
      },
    );
  }
}

class Choice {
  const Choice({required this.title, this.icon, this.onPressed});

  final IconData? icon;
  final String title;
  final Function? onPressed;
}
