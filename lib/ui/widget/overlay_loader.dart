import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class CustomLoader {
  static CustomLoader _customLoader;

  static CustomLoader get instance => _customLoader;

  factory CustomLoader() {
    if (_customLoader != null) {
      return _customLoader;
    } else {
      return _customLoader = CustomLoader._createObject();
    }
  }
  CustomLoader._createObject();

  //static OverlayEntry _overlayEntry;
  OverlayState _overlayState; //= new OverlayState();
  OverlayEntry _overlayEntry;

  void _buildLoader({String message}) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
            height: context.width,
            width: context.height,
            child: buildLoader(context, message: message));
      },
    );
  }

  void showLoader(BuildContext context, {String message}) {
    _overlayState = Overlay.of(context);
    _buildLoader(message: message);
    _overlayState.insert(_overlayEntry);
  }

  void hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      Utility.cprint("Exception:: $e");
    }
  }

  Widget buildLoader(BuildContext context,
      {Color backgroundColor, String message}) {
    backgroundColor ??= const Color(0xffa8a8a8).withOpacity(.5);
    const height = 140.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScreenLoader(
          height: height,
          width: height,
          backgroundColor: backgroundColor,
          message: message,
          onTap: () {
            hideLoader();
          }),
    );
  }
}

class CustomScreenLoader extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final double width;
  final GestureTapCallback onTap;
  final String message;
  const CustomScreenLoader(
      {Key key,
      this.backgroundColor = const Color(0xfff8f8f8),
      this.height = 40,
      this.width = 40,
      this.onTap,
      this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: Container(
          height: height,
          width: height,
          alignment: Alignment.center,
          child: Container(
            height: height,
            width: height,
            // padding: EdgeInsets.all(30),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height - 50,
                  width: height - 50,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: <Widget>[
                      if (Platform.isIOS)
                        const CupertinoActivityIndicator(radius: 45)
                      else
                        const CircularProgressIndicator(strokeWidth: 2),
                      Center(
                        child: Image.asset(
                          Images.twitterLogo,
                          height: 40,
                          width: 40,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    ],
                  ),
                ),
                if (message != null)
                  Text(
                    message,
                    style: TextStyles.subtitle16(context),
                    overflow: TextOverflow.ellipsis,
                  ).pT(10).hP8
              ],
            ),
          ),
        ),
      ),
    );
  }
}
