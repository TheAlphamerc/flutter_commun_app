import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';

class OTPVerificationPAge extends StatefulWidget {
  final Function(String otp) onSubmit;
  const OTPVerificationPAge({Key? key, required this.onSubmit})
      : super(key: key);
  static MaterialPageRoute getRoute(Function(String otp) onSubmit) {
    return MaterialPageRoute(
        builder: (BuildContext context) =>
            OTPVerificationPAge(onSubmit: onSubmit));
  }

  @override
  _OTPVerificationPAgeState createState() => _OTPVerificationPAgeState();
}

class _OTPVerificationPAgeState extends State<OTPVerificationPAge> {
  late FocusNode node1;
  late FocusNode node2;
  late FocusNode node3;
  late FocusNode node4;
  late FocusNode node5;
  late FocusNode node6;
  late TextEditingController otp1;
  late TextEditingController otp2;
  late TextEditingController otp3;
  late TextEditingController otp4;
  late TextEditingController otp5;
  late TextEditingController otp6;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    node1 = FocusNode();
    node2 = FocusNode();
    node3 = FocusNode();
    node4 = FocusNode();
    node5 = FocusNode();
    node6 = FocusNode();

    otp1 = TextEditingController();
    otp2 = TextEditingController();
    otp3 = TextEditingController();
    otp4 = TextEditingController();
    otp5 = TextEditingController();
    otp6 = TextEditingController();
  }

  @override
  void dispose() {
    node1.dispose();
    node2.dispose();
    node3.dispose();
    node4.dispose();
    node5.dispose();
    node6.dispose();

    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    otp5.dispose();
    otp6.dispose();
    super.dispose();
  }

  Widget _button(BuildContext context,
      {required String title, Color? backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: submitOTP,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.disabledColor),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            side: MaterialStateProperty.all(const BorderSide(width: .3))),
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
      {required TextEditingController controller,
      required FocusNode node,
      required Function(String) onChanged}) {
    return SizedBox(
      width: 40,
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
    if (value.isEmpty) {
      FocusScope.of(context).previousFocus();
    }
  }

  void submitOTP() {
    final otp =
        otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;
    if (otp.isEmpty || otp.length < 6) {
      Utility.cprint("Invalid OTP");
      return;
    }
    FocusManager.instance.primaryFocus!.unfocus();
    widget.onSubmit(otp);
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _otp(
                          controller: otp1,
                          node: node1,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              return;
                            }
                            changeFocus(value, node2);
                          }),
                      _otp(
                          controller: otp2,
                          node: node2,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              FocusScope.of(context).previousFocus();
                              return;
                            }
                            changeFocus(value, node3);
                          }),
                      _otp(
                          controller: otp3,
                          node: node3,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              FocusScope.of(context).previousFocus();
                              return;
                            }
                            changeFocus(value, node4);
                          }),
                      _otp(
                          controller: otp4,
                          node: node4,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              FocusScope.of(context).previousFocus();
                              return;
                            }
                            changeFocus(value, node5);
                          }),
                      _otp(
                          controller: otp5,
                          node: node5,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              FocusScope.of(context).previousFocus();
                              return;
                            }
                            changeFocus(value, node6);
                          }),
                      _otp(
                          controller: otp6,
                          node: node6,
                          onChanged: (value) {
                            if (value.length == 1) {
                              node6.unfocus();
                            }
                            if (value.isEmpty) {
                              FocusScope.of(context).previousFocus();
                            }
                          }),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.locale.resend_verfication_code,
                    style: TextStyles.headline14(context).primary(context),
                  ),
                  const SizedBox(height: 100),
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
    Key? key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.textInputAction,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40,
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller ?? TextEditingController(),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        // cursorHeight: 20,
        keyboardType: TextInputType.phone,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            filled: true,
            fillColor: KColors.light_gray,
            contentPadding: const EdgeInsets.only(bottom: 10)),

        showCursor: true,
        cursorRadius: const Radius.circular(5),
        style: TextStyles.headline20(context),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.deny(RegExp("[^0-9]"))
        ],
        focusNode: focusNode,
        onChanged: onChanged,
      ),
    );
  }
}
