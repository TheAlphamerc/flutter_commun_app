import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _body() {
    const height = 150.0;
    return SizedBox(
      height: context.height,
      width: context.width,
      child: Container(
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(50),
          decoration: const BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (Platform.isIOS)
                const CupertinoActivityIndicator(
                  radius: 35,
                )
              else
                const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              const FlutterLogo()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }
}
