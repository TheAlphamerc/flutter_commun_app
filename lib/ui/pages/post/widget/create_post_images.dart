import 'dart:io';

import 'package:flutter/material.dart';

class CreatePostImage extends StatelessWidget {
  final File? image;
  final void Function(File)? onImageRemove;
  const CreatePostImage({Key? key, this.image, this.onImageRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: image == null
          ? Container()
          : Stack(
              children: <Widget>[
                InteractiveViewer(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: FileImage(image!), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    // padding: EdgeInsets.all(0),
                    height: 25,
                    width: 25,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black54),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      iconSize: 20,
                      onPressed: () => onImageRemove!.call(image!),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
