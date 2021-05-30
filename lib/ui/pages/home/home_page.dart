import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/home/feed/post_feed_cubit.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/post/post_repo.dart';
import 'package:flutter_commun_app/ui/pages/home/feed/feed_page.dart';
import 'package:flutter_commun_app/ui/pages/home/widget/bottom_navigation_menu.dart';
import 'package:flutter_commun_app/ui/pages/home/widget/feed_app_bar.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static Route<T> getRoute<T>() {
    return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(providers: [
              BlocProvider(
                create: (context) =>
                    PostFeedCubit(getIt<PostRepo>())..getPosts(),
              ),
            ], child: const HomePage()));
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
      body: const Feedpage(),
    );
  }
}
