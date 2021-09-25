import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/validator.dart';

enum FieldType {
  name,
  email,
  phone,
  password,
  confirmPassword,
  reset,
  text,
  optional,
  url
}

class KTextField extends StatelessWidget {
  const KTextField(
      {Key? key,
      this.controller,
      this.label,
      required this.type,
      this.maxLines = 1,
      this.hintText = '',
      this.height = 70,
      this.onSubmit,
      this.suffixIcon,
      this.onChange,
      this.validator,
      this.obscureText = false,
      this.textCapitalization = TextCapitalization.sentences,
      this.padding = const EdgeInsets.all(0),
      this.inputFormatters,
      this.backgroundColor})
      : super(key: key);
  final TextEditingController? controller;
  final String? label, hintText;
  final FieldType type;
  final int maxLines;
  final double height;
  final Widget? suffixIcon;
  final bool? obscureText;
  final Function(String)? onSubmit;
  final EdgeInsetsGeometry padding;
  final TextCapitalization textCapitalization;
  final Function(String)? onChange;
  final String? Function(String?)? validator;
  final Color? backgroundColor;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null) ...[
          Text(label ?? "", style: TextStyles.headline16(context)),
          const SizedBox(height: 5),
        ],
        SizedBox(
          height: height,
          child: TextFormField(
            autocorrect: false,
            onSaved: (val) {
              // print(val);
            },
            onFieldSubmitted: (val) {
              if (onSubmit != null) {
                onSubmit!.call(val);
              }
            },
            inputFormatters: inputFormatters,
            obscureText: obscureText!,
            maxLines: maxLines,
            onChanged: onChange,
            textCapitalization: textCapitalization,
            keyboardType: getKeyboardType(type),
            controller: controller ?? TextEditingController(),
            decoration: getInputDecotration(context,
                hintText: hintText, suffixIcon: suffixIcon),
            textInputAction: (type == FieldType.password ||
                    type == FieldType.reset ||
                    type == FieldType.confirmPassword)
                ? TextInputAction.done
                : TextInputAction.next,
            validator: validator ??
                (String? val) => KValidator.buildValidators(
                      val,
                      context: context,
                      choice: type,
                    ),
          ),
        ),
      ],
    );
  }

  InputDecoration getInputDecotration(BuildContext context,
      {String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
        // helperText: '',
        hintText: hintText,
        fillColor: backgroundColor ?? Colors.transparent,
        filled: backgroundColor != null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
        suffixIcon: suffixIcon);
  }

  TextInputType? getKeyboardType(FieldType choice) {
    switch (choice) {
      case FieldType.name:
        return TextInputType.text;
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.password:
        return null;
      case FieldType.confirmPassword:
        return null;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.reset:
        return TextInputType.emailAddress;
      case FieldType.url:
        return TextInputType.url;
      default:
        return TextInputType.text;
    }
  }
}
