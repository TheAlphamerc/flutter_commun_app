import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/cubit/app_start/onboard/onboard_profile_cubit.dart';
import 'package:flutter_commun_app/resource/repository/profile/profile_repo.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';

class OnBoardUserProfilePage extends StatelessWidget {
  const OnBoardUserProfilePage({Key key, this.model}) : super(key: key);
  final ProfileModel model;

  static Route<T> getRoute<T>(ProfileModel model) {
    return MaterialPageRoute<T>(builder: (_) {
      return BlocProvider(
        create: (context) => OnboardProfileCubit(model, getIt<ProfileRepo>()),
        child: OnBoardUserProfilePage(),
      );
    });
  }

  Widget _button(BuildContext context, {String title, Color backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus.unfocus();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.disabledColor),
            padding:
                MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 20)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
            side: MaterialStateProperty.all(BorderSide(width: .3))),
        child: Text(
          title,
          style: TextStyles.headline16(context).copyWith(
            color: context.onPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5FA),
      appBar: AppBar(
        centerTitle: true,
        title: Title(
            color: Colors.white,
            child: Text(
              "General Info",
              style: TextStyles.headline18(context),
            )),
        backgroundColor: context.theme.appBarTheme.backgroundColor,
      ),
      body: Container(
        width: context.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              Container(
                width: context.width,
                margin: EdgeInsets.symmetric(horizontal: 12),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecorations.decoration(context,
                    offset: Offset(0, 0), blurRadius: 2),
                child: Column(
                  children: [
                    _UserAvatar().pB(30),
                    _ProfileBanner().pB(30),
                    UsernameField(label: "Name", type: FieldType.name).pB(10),
                    UsernameField(label: "UserName", type: FieldType.name)
                        .pB(10),
                    UsernameField(label: "Website", type: FieldType.name)
                        .pB(10),
                    UsernameField(label: "Bio", type: FieldType.name).pB(20),
                  ],
                ),
              ).pB(20),
              _button(context,
                  title: "Save", backgroundColor: context.primaryColor),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key key,
  }) : super(key: key);

  void pickImage(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return context.watch<OnboardProfileCubit>().image.fold(
          () => Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomPaint(
                painter: CirclePainter(color: theme.disabledColor),
                child: Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(Images.onBoardPicFour),
                ),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: CircleAvatar(
                  backgroundColor: theme.primaryColor,
                  child: Icon(Icons.camera),
                ).ripple(() {
                  pickImage(context);
                }),
              )
            ],
          ).ripple(() {
            pickImage(context);
          }),
          (image) => SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecorations.decoration(context).copyWith(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xffaaaaaa),
                            offset: Offset(3, 3),
                            blurRadius: 10)
                      ]),
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                    backgroundColor: theme.primaryColor,
                    child: Icon(Icons.camera),
                  ).ripple(() {
                    pickImage(context);
                  }),
                )
              ],
            ),
          ),
        );
    ;
  }
}

class _ProfileBanner extends StatelessWidget {
  const _ProfileBanner({
    Key key,
  }) : super(key: key);

  void pickImage(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return context.watch<OnboardProfileCubit>().image.fold(
          () => Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: context.width,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.grey.shade200,
                    child: Image.asset(Images.onBoardPicTwo),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: CircleAvatar(
                  backgroundColor: theme.primaryColor,
                  child: Icon(Icons.camera),
                ).ripple(() {
                  pickImage(context);
                }),
              ).p16
            ],
          ).ripple(() {
            pickImage(context);
          }),
          (image) => SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecorations.decoration(context).copyWith(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xffaaaaaa),
                            offset: Offset(3, 3),
                            blurRadius: 10)
                      ]),
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                    backgroundColor: theme.primaryColor,
                    child: Icon(Icons.camera),
                  ).ripple(() {
                    pickImage(context);
                  }),
                )
              ],
            ),
          ),
        );
    ;
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final double stroke;

  CirclePainter({this.color = Colors.black, this.stroke = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;

    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class UsernameField extends StatelessWidget {
  const UsernameField(
      {Key key,
      this.controller,
      this.label,
      @required this.type,
      this.maxLines = 1,
      this.hintText = '',
      this.height = 70,
      this.onSubmit,
      this.onChange,
      this.validator,
      this.obscureText = false,
      this.padding = const EdgeInsets.all(0)})
      : super(key: key);

  final TextEditingController controller;
  final String label, hintText;
  final FieldType type;
  final int maxLines;
  final double height;

  final bool obscureText;
  final Function(String) onSubmit;
  final EdgeInsetsGeometry padding;
  final Function(String) onChange;
  final Function(String) validator;

  Widget field(BuildContext context, dartz.Option<bool> val) {
    return TextField(
      autocorrect: false,
      obscureText: obscureText,
      maxLines: maxLines,
      onChanged: onChange,
      keyboardType: TextInputType.text,
      scrollPadding: EdgeInsets.zero,
      controller: controller ?? TextEditingController(),
      decoration: getInputDecotration(
        context,
        hintText: hintText,
        isValid: val,
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecorations.outlineBorder(context, radius: 10, width: 1),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyles.subtitle14(context)),
          SizedBox(height: 30, child: field(context, dartz.none())),
        ],
      ),
    );
  }

  InputDecoration getInputDecotration(context,
      {String hintText, Widget suffixIcon, dartz.Option<bool> isValid}) {
    return InputDecoration(
      // helperText: '',
      hintText: hintText,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      suffixIcon: suffixIcon,
    );
  }
}
