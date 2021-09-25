import 'package:dartz/dartz.dart';
import 'package:flutter_commun_app/ui/widget/form/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class KTextField2 extends StatelessWidget {
  const KTextField2({
    Key? key,
    this.controller,
    required this.label,
    required this.type,
    this.maxLines = 1,
    this.height = 70,
    this.readOnly = false,
    this.containerDecoration,
  }) : super(key: key);

  final TextEditingController? controller;
  final String label;
  final FieldType type;
  final int maxLines;
  final double height;
  final bool readOnly;
  final Decoration? containerDecoration;

  Widget field(BuildContext context, Option<bool> val) {
    return TextFormField(
      autocorrect: false,
      maxLines: maxLines,
      keyboardType: TextInputType.text,
      scrollPadding: EdgeInsets.zero,
      controller: controller ?? TextEditingController(),
      style: TextStyles.headline16(context),
      decoration: getInputDecotration(context),
      readOnly: readOnly,
      validator: (String? val) => KValidator.buildValidators(
        val,
        context: context,
        choice: type,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: containerDecoration ??
          BoxDecorations.outlineBorder(context, radius: 10, width: 1).copyWith(
              color: !readOnly
                  ? context.onPrimary
                  : context.disabledColor.withOpacity(.07)),
      padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyles.subtitle14(context)),
          SizedBox(child: field(context, none()))
              .pT(8.0 + (maxLines > 1 ? 8 : -1)),
        ],
      ),
    );
  }

  InputDecoration getInputDecotration(BuildContext context,
      {String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      suffixIcon: suffixIcon,
    );
  }
}
