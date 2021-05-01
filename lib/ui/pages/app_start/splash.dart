import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/pages/app_start/welcome/onboard_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget _body() {
    var height = 150.0;
    return Container(
      height: context.height,
      width: context.width,
      child: Container(
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Platform.isIOS
                  ? CupertinoActivityIndicator(
                      radius: 35,
                    )
                  : CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
              FlutterLogo()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _body();
          } else if (snapshot.data == null) {
            return GetStartedPage();
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                height: context.height,
                width: context.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Home page"),
                    SizedBox(height: 40),
                    OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        setState(() {});
                      },
                      child: Text("Logout"),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
