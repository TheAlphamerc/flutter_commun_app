import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/cubit/app/app_cubit.dart';
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
      appBar: AppBar(),
      body: Container(
        height: context.height,
        width: context.width,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home page"),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () {
                context.read<AppCubit>().logout();
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
