import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/pages/post/create_post_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class BottomNavigationMenu extends StatelessWidget {
  const BottomNavigationMenu({Key key}) : super(key: key);
  Widget _icon(BuildContext context, {IconData icon, VoidCallback onPressed}) {
    return IconButton(icon: Icon(icon), onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            _icon(context, icon: Icons.home, onPressed: () {}).extended,
            _icon(context, icon: Icons.explore, onPressed: () {}),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context, CreatePostPage.getRoute());
              },
              mini: true,
              backgroundColor: context.primaryColor,
              child: Icon(
                Icons.add,
                color: context.onPrimary,
                size: 25,
              ),
            ).extended,
            _icon(context, icon: Icons.people, onPressed: () {}),
            _icon(context, icon: Icons.account_circle, onPressed: () {})
                .extended,
          ],
        ),
      ),
    );
  }
}
