// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/kit/custom_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';

// ignore: avoid_classes_with_only_static_members
class FileUtility {
  /// Pick image from device
  static Future<Option<File>> pickImage() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final PlatformFile file = result.files.first;
      return some(File(file.path!));
    }
    return none();
  }

  /// Display bottom sheet to provide option to choose between camera/gallery
  static void chooseImageBottomSheet(
    BuildContext context,
    Function(Option<File>) onSelected,
  ) {
    sheet.displayBottomSheet(
      context,
      headerChild: Text("Choose Image", style: TextStyles.headline16(context)),
      sheetButton: [
        PrimarySheetButton(
          icon: Icons.camera_alt_outlined,
          title: "From Camera",
          onPressed: () {
            _setImage(context, ImageSource.camera, onSelected);
            Navigator.pop(context);
          },
        ),
        PrimarySheetButton(
          icon: Icons.image_outlined,
          title: "From Gallery",
          onPressed: () {
            _setImage(context, ImageSource.gallery, onSelected);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  static void _setImage(BuildContext context, ImageSource source,
      Function(Option<File>) onSelected) {
    switch (source) {
      case ImageSource.gallery:
        ImagePicker()
            .getImage(source: ImageSource.gallery, imageQuality: 20)
            .then((PickedFile? file) {
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
            .then((PickedFile? file) {
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
