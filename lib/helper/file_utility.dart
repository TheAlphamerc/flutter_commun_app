import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:image_picker/image_picker.dart';

mixin FileUtility {
  /// Pick image from device
  static Future<Option<File>> pickImage() async {
    final FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );
    if (result != null) {
      final PlatformFile file = result.files.first;
      return some(File(file.path));
    }
    return none();
  }

  /// Display bottom sheet to provide option to choose between camera/gallery
  static void chooseImageBottomSheet(
      BuildContext context, Function(Option<File>) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.red,
      builder: (BuildContext _) {
        return BottomSheet(
          onClosing: () {},
          enableDrag: false,
          builder: (_) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Choose Image",
                          style: TextStyles.headline16(context)),
                      const Spacer(),
                      CircleAvatar(
                        radius: 15,
                        foregroundColor: context.theme.iconTheme.color,
                        backgroundColor: context.onPrimary,
                        child: const Icon(Icons.close),
                      ).ripple(() {
                        Navigator.pop(context);
                      })
                    ],
                  ).pV(15),
                  _button(context, "From Camera", Icons.camera_alt_outlined,
                      () {
                    _setImage(context, ImageSource.camera, onSelected);
                    Navigator.pop(context);
                  }),
                  _button(context, "From Gallery", Icons.image_outlined, () {
                    _setImage(context, ImageSource.gallery, onSelected);
                    Navigator.pop(context);
                  }),
                  const SizedBox(height: 30)
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Widget _button(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return Container(
      decoration: BoxDecorations.decoration(context,
          borderRadius: 10, offset: const Offset(0, 0), blurRadius: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.headline14(context)),
          Icon(icon)
        ],
      ),
    ).ripple(onPressed, borderRadius: BorderRadius.circular(10)).pV(10);
  }

  static void _setImage(BuildContext context, ImageSource source,
      Function(Option<File>) onSelected) {
    switch (source) {
      case ImageSource.gallery:
        // FileUtility.pickImage().then((file) {
        //   onSelected(file);
        // });
        ImagePicker()
            .getImage(source: ImageSource.gallery, imageQuality: 20)
            .then((PickedFile file) {
          if (file != null) {
            onSelected(some(File(file.path)));
          } else {
            onSelected(none());
          }
        });
        break;
      default:
        ImagePicker()
            .getImage(source: ImageSource.camera, imageQuality: 20)
            .then((PickedFile file) {
          if (file != null) {
            onSelected(some(File(file.path)));
          } else {
            onSelected(none());
          }
        });
        break;
    }
  }
}
