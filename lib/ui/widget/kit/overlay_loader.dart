import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

abstract class LoaderService {
  static final LoaderService _instance = CustomLoader();

  /// access to the Singleton instance of LoaderService
  static LoaderService get instance => _instance;

  /// Short form to access the instance of LoaderService
  static LoaderService get I => _instance;

  void showLoader(BuildContext context,
      {String message, Stream<String> progress});

  void hideLoader();
}

class CustomLoader implements LoaderService {
  // static CustomLoader _customLoader = CustomLoader();

  // static CustomLoader get instance => _customLoader;

  // factory CustomLoader() {
  //   if (_customLoader != null) {
  //     return _customLoader;
  //   } else {
  //     return _customLoader = CustomLoader._createObject();
  //   }
  // }
  // CustomLoader._createObject();

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  void _buildLoader({String? message, Stream<String>? progress}) {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return SizedBox(
            height: context.height,
            width: context.width,
            child: buildLoader(context, message: message, progress: progress));
      },
    );
  }

  @override
  void showLoader(BuildContext context,
      {String? message, Stream<String>? progress}) {
    _overlayState = Overlay.of(context);
    _buildLoader(message: message, progress: progress);
    _overlayState!.insert(_overlayEntry!);
  }

  @override
  void hideLoader() {
    try {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } catch (e) {
      Utility.cprint("Exception:: $e");
    }
  }

  Widget buildLoader(BuildContext context,
      {Color? backgroundColor, String? message, Stream<String>? progress}) {
    backgroundColor ??= const Color(0xffa8a8a8).withOpacity(.5);
    const height = 140.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _CustomScreenLoader(
          height: height,
          width: height,
          backgroundColor: backgroundColor,
          message: message,
          progress: progress,
          onTap: () {
            hideLoader();
          }),
    );
  }
}

class _CustomScreenLoader extends StatelessWidget {
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final String? message;
  final Stream<String>? progress;
  const _CustomScreenLoader({
    Key? key,
    this.backgroundColor = const Color(0xfff8f8f8),
    this.height = 40,
    this.width = 40,
    this.onTap,
    this.message,
    this.progress,
  }) : super(key: key);

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
                  height: height! - 50,
                  width: height! - 50,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: <Widget>[
                      const CircularProgressIndicator.adaptive(strokeWidth: 2),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: progress,
                        initialData: "",
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.data.isNotNullEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            "${snapshot.data} ",
                            style: TextStyles.subtitle16(context),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      Center(
                        child: Text(
                          message!,
                          style: TextStyles.subtitle16(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ).extended
                    ],
                  ).pT(10).hP8,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
