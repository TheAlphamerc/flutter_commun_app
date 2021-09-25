import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app/bottom_menu/bottom_main_menu_cubit.dart';
import 'package:flutter_commun_app/cubit/community/feed/community_feed_cubit.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/ui/pages/post/create_post_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class BottomNavigationMenu extends StatelessWidget {
  const BottomNavigationMenu({Key? key}) : super(key: key);
  Widget _icon(BuildContext context,
      {required IconData icon, required VoidCallback onPressed}) {
    return IconButton(icon: Icon(icon), onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            _icon(context, icon: Icons.home, onPressed: () {
              context.read<BottomMainMenuCubit>().updateCurrentPageIndex(0);
            }).extended,
            _icon(context, icon: Icons.explore, onPressed: () {
              context.read<BottomMainMenuCubit>().updateCurrentPageIndex(1);
            }),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CreatePostPage.getRoute2(
                        context.read<CommunityFeedCubit>()));
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
