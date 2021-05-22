import 'package:flutter/material.dart';

import 'package:flutter_commun_app/ui/pages/home/widget/bottom_navigation_menu.dart';
import 'package:flutter_commun_app/ui/pages/home/widget/feed_app_bar.dart';
import 'package:flutter_commun_app/ui/pages/home/widget/whats_new_widget.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static Route<T> getRoute<T>() {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: const FeedAppBar(),
      bottomNavigationBar: const BottomNavigationMenu(),
      body: Container(
        height: context.height,
        width: context.width,
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 10),
            WhatsNewWidget(),
          ],
        ),
      ),
    );
  }
}
