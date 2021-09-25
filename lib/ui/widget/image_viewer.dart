import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  static MaterialPageRoute getRoute(String path) {
    return MaterialPageRoute(
      builder: (_) => ImageViewer(
        path: path,
      ),
    );
  }

  const ImageViewer({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(
          minScale: .3,
          maxScale: 5,
          child: CachedNetworkImage(imageUrl: path),
        ),
      ),
    );
  }
}

class CacheImage extends StatelessWidget {
  const CacheImage(
      {Key? key, required this.path, this.onPressed, this.fit = BoxFit.contain})
      : super(key: key);
  final String path;
  final BoxFit fit;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ??
          () {
            Navigator.push(context, ImageViewer.getRoute(path));
          },
      child: CachedNetworkImage(
        imageUrl: path,
        fit: fit,
      ),
    );
  }
}
