import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class CustomLoader {
  static CustomLoader _customLoader;

  CustomLoader._createObject();

  factory CustomLoader() {
    if (_customLoader != null) {
      return _customLoader;
    } else {
      _customLoader = CustomLoader._createObject();
      return _customLoader;
    }
  }

  //static OverlayEntry _overlayEntry;
  OverlayState _overlayState; //= new OverlayState();
  OverlayEntry _overlayEntry;

  _buildLoader({String message}) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Container(
            height: context.width,
            width: context.height,
            child: buildLoader(context, message: message));
      },
    );
  }

  showLoader(context, {String message}) {
    _overlayState = Overlay.of(context);
    _buildLoader(message: message);
    _overlayState.insert(_overlayEntry);
  }

  hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      print("Exception:: $e");
    }
  }

  buildLoader(BuildContext context, {Color backgroundColor, String message}) {
    if (backgroundColor == null) {
      backgroundColor = const Color(0xffa8a8a8).withOpacity(.5);
    }
    var height = 140.0;
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
  final Function onTap;
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
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: height - 50,
                  width: height - 50,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Platform.isIOS
                          ? CupertinoActivityIndicator(
                              radius: 45,
                            )
                          : CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
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
