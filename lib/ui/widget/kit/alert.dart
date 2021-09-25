import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

// ignore: avoid_classes_with_only_static_members
class Alert {
  static void confirmDialog(
    BuildContext context, {
    String? title,
    required String message,
    String cancelText = "Cancel",
    String confirmText = "Confirm",
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title ?? "Message", style: TextStyles.headline16(context))
                    .pB(20),
                Text(
                  message,
                  style: TextStyles.bodyText15(context),
                  textAlign: TextAlign.center,
                ).vP16,
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          if (onCancel != null) {
                            onCancel();
                          }
                          Navigator.pop(context);
                        },
                        child: Text(cancelText)),
                    MaterialButton(
                      onPressed: () {
                        if (onConfirm != null) {
                          onConfirm();
                        }
                        Navigator.pop(context);
                      },
                      color: context.primaryColor,
                      textColor: context.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(confirmText),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static void displayDialog(BuildContext context,
      {String? title, required String message, required Widget child}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title ?? "Message", style: TextStyles.headline16(context))
                    .pB(20),
                child
              ],
            ),
          ),
        );
      },
    );
  }
}
