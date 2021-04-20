import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/signup/signup_cubit.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class OTPVerificationPAge extends StatefulWidget {
  const OTPVerificationPAge({Key key}) : super(key: key);
  static MaterialPageRoute getRoute(SignupCubit cubit) {
    return MaterialPageRoute(
      builder: (BuildContext context) => BlocProvider.value(
        value: cubit,
        child: OTPVerificationPAge(),
      ),
    );
  }

  @override
  _OTPVerificationPAgeState createState() => _OTPVerificationPAgeState();
}

class _OTPVerificationPAgeState extends State<OTPVerificationPAge> {
  FocusNode node1;
  FocusNode node2;
  FocusNode node3;
  FocusNode node4;
  TextEditingController otp1;
  TextEditingController otp2;
  TextEditingController otp3;
  TextEditingController otp4;
  @override
  void initState() {
    super.initState();
    node1 = FocusNode();
    node2 = FocusNode();
    node3 = FocusNode();
    node4 = FocusNode();

    otp1 = TextEditingController();
    otp2 = TextEditingController();
    otp3 = TextEditingController();
    otp4 = TextEditingController();
  }

  @override
  void dispose() {
    node1.dispose();
    node2.dispose();
    node3.dispose();
    node4.dispose();

    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    super.dispose();
  }

  Widget _button(BuildContext context, {String title, Color backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.disabledColor),
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            side: MaterialStateProperty.all(BorderSide(width: .3))),
        child: Text(
          title,
          style: TextStyles.headline16(context).copyWith(
            color: context.onPrimary,
          ),
        ),
      ).pH(24),
    );
  }

  Widget _otp(
      {TextEditingController controller,
      FocusNode node,
      Function(String) onChanged}) {
    return SizedBox(
      width: 50,
      child: CustomOTPTextField(
        controller: controller,
        onChanged: onChanged,
        focusNode: node,
      ),
    ).pH(6);
  }

  ///Changing Focus to next `OTP`
  void changeFocus(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
    if (value.length == 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Text(
              context.locale.close,
              style: TextStyles.headline18(context).primary(context),
            ),
          ),
        ).circular,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.locale.verfication,
                style: TextStyles.headline36(context),
              ).pB(19),
              Text(
                context.locale.enter_sms_code,
                style: TextStyles.headline20(context),
              ).pB(90),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _otp(
                          controller: otp1,
                          node: node1,
                          onChanged: (value) {
                            if (value.length == 0) {
                              return;
                            }
                            changeFocus(value, node2);
                          }),
                      _otp(
                          controller: otp2,
                          node: node2,
                          onChanged: (value) {
                            if (value.length == 0) {
                              return;
                            }
                            changeFocus(value, node3);
                          }),
                      _otp(
                          controller: otp3,
                          node: node3,
                          onChanged: (value) {
                            if (value.length == 0) {
                              return;
                            }
                            changeFocus(value, node4);
                          }),
                      _otp(
                          controller: otp4,
                          node: node4,
                          onChanged: (value) {
                            if (value.length == 1) {
                              node4.unfocus();
                            }
                            if (value.length == 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    context.locale.resend_verfication_code,
                    style: TextStyles.headline14(context).primary(context),
                  ),
                  SizedBox(height: 100),
                  _button(context,
                          title: context.locale.next,
                          backgroundColor: context.primaryColor)
                      .pB(40),
                ],
              ).extended
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOTPTextField extends StatelessWidget {
  const CustomOTPTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.textInputAction,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 60,
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller ?? TextEditingController(),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        cursorHeight: 20,
        keyboardType: TextInputType.phone,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          filled: true,
          fillColor: KColors.middle_gray_2,
        ),
        showCursor: true,
        cursorRadius: Radius.circular(5),
        style: TextStyles.headline26(context),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        focusNode: focusNode,
        onChanged: onChanged,
      ),
    );
  }
}
