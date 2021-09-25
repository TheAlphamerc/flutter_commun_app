import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app/app_cubit.dart';
import 'package:flutter_commun_app/cubit/app_start/onboard/onboard_profile_cubit.dart';
import 'package:flutter_commun_app/helper/file_utility.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/model/profile/profile_model.dart';
import 'package:flutter_commun_app/resource/repository/profile/profile_repo.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/form/k_textfield.dart';
import 'package:flutter_commun_app/ui/widget/form/validator.dart';
import 'package:flutter_commun_app/ui/widget/painter/circle_border_painter.dart';

class OnBoardUserProfilePage extends StatelessWidget {
  const OnBoardUserProfilePage({Key? key}) : super(key: key);

  static Route<T> getRoute<T>(ProfileModel model) {
    return MaterialPageRoute<T>(builder: (_) {
      return BlocProvider(
        create: (context) => OnboardProfileCubit(model, getIt<ProfileRepo>()),
        child: const OnBoardUserProfilePage(),
      );
    });
  }

  Widget _button(BuildContext context,
      {required String title, Color? backgroundColor}) {
    return IntrinsicWidth(
      stepWidth: context.width - 32,
      child: TextButton(
        onPressed: () async {
          FocusManager.instance.primaryFocus!.unfocus();
          context.read<OnboardProfileCubit>().submit(context);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                backgroundColor ?? context.disabledColor),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
            side: MaterialStateProperty.all(const BorderSide(width: .3))),
        child: Text(
          title,
          style: TextStyles.headline16(context).copyWith(
            color: context.onPrimary,
          ),
        ),
      ),
    );
  }

  void listener(BuildContext context, OnboardProfileState state) {
    state.when(
        initial: (s) {},
        response: (eResponse, message) {
          eResponse.when(
            error: () {
              Utility.displaySnackbar(context,
                  msg: Utility.decodeStateMessage(message));
            },
            updated: () async {
              Utility.displaySnackbar(context,
                  msg: Utility.decodeStateMessage(message));
              await Future.delayed(const Duration(milliseconds: 500));
              context.read<AppCubit>().checkAuthentication();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F5FA),
      appBar: AppBar(
        centerTitle: true,
        title: Title(
            color: Colors.white,
            child: Text(
              context.locale.general_info,
              style: TextStyles.headline18(context),
            )),
        backgroundColor: context.theme.appBarTheme.backgroundColor,
      ),
      body: BlocListener<OnboardProfileCubit, OnboardProfileState>(
        listener: listener,
        child: SizedBox(
          width: context.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: context.width,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecorations.decoration(context,
                      offset: const Offset(0, 0), blurRadius: 2),
                  child: Form(
                    key: context.watch<OnboardProfileCubit>().formKey,
                    child: Column(
                      children: [
                        const _UserAvatar().pB(10),
                        const _ProfileBanner().pB(20),
                        _CustomInputField(
                                label: context.locale.name,
                                type: FieldType.name,
                                controller:
                                    context.watch<OnboardProfileCubit>().name)
                            .pB(10),
                        _CustomInputField(
                                label: context.locale.username,
                                type: FieldType.text,
                                readOnly: true,
                                controller: context
                                    .watch<OnboardProfileCubit>()
                                    .username)
                            .pB(10),
                        _CustomInputField(
                                label: context.locale.website,
                                type: FieldType.url,
                                controller: context
                                    .watch<OnboardProfileCubit>()
                                    .website)
                            .pB(10),
                        _CustomInputField(
                            label: context.locale.bio,
                            type: FieldType.optional,
                            maxLines: 4,
                            controller:
                                context.watch<OnboardProfileCubit>().bio),
                      ],
                    ),
                  ),
                ).pB(20),
                _button(context,
                    title: context.locale.save,
                    backgroundColor: context.primaryColor),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key? key,
  }) : super(key: key);

  void pickImage(BuildContext context) {
    FileUtility.chooseImageBottomSheet(context, (file) {
      context.read<OnboardProfileCubit>().updateImage(image: file);
    });
  }

  Widget _cameraIcon(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: CircleAvatar(
        backgroundColor: context.primaryColor,
        child: Icon(
          Icons.camera_alt,
          color: context.onPrimary,
        ),
      ).ripple(() {
        pickImage(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.select((OnboardProfileCubit cubit) => cubit.image).fold(
          () => Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomPaint(
                painter: CircleBorderPainter(color: context.disabledColor),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(Images.onBoardPicFour),
                ),
              ),
              _cameraIcon(context),
            ],
          ).ripple(() {
            pickImage(context);
          }, borderRadius: BorderRadius.circular(100)),
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
                        const BoxShadow(
                            color: Color(0xffaaaaaa),
                            offset: Offset(3, 3),
                            blurRadius: 10)
                      ]),
                ),
                _cameraIcon(context),
              ],
            ),
          ),
        );
  }
}

class _ProfileBanner extends StatelessWidget {
  const _ProfileBanner({
    Key? key,
  }) : super(key: key);

  void pickImage(BuildContext context) {
    FileUtility.chooseImageBottomSheet(context, (file) {
      context.read<OnboardProfileCubit>().updateImage(banner: file);
    });
  }

  Widget _cameraIcon(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: CircleAvatar(
        backgroundColor: context.primaryColor,
        child: Icon(
          Icons.camera_alt,
          color: context.onPrimary,
        ),
      ).ripple(() {
        pickImage(context);
      }),
    ).p16;
  }

  @override
  Widget build(BuildContext context) {
    return context.select(
      (OnboardProfileCubit cubit) => cubit.banner.fold(
        () => Stack(
          alignment: Alignment.bottomRight,
          children: [
            SizedBox(
              width: context.width,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.grey.shade200,
                  child: Image.asset(Images.onBoardPicTwo),
                ),
              ),
            ),
            _cameraIcon(context)
          ],
        ).ripple(() {
          pickImage(context);
        }),
        (image) => Stack(
          alignment: Alignment.bottomRight,
          children: [
            SizedBox(
              width: context.width,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecorations.decoration(context).copyWith(
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: FileImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            _cameraIcon(context)
          ],
        ).ripple(() {
          pickImage(context);
        }),
      ),
    );
  }
}

class _CustomInputField extends StatelessWidget {
  const _CustomInputField({
    Key? key,
    required this.controller,
    required this.label,
    required this.type,
    this.maxLines = 1,
    this.height = 70,
    this.readOnly = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final FieldType type;
  final int maxLines;
  final double height;
  final bool readOnly;

  Widget field(BuildContext context, dartz.Option<bool> val) {
    return TextFormField(
      autocorrect: false,
      maxLines: maxLines,
      keyboardType: TextInputType.text,
      scrollPadding: EdgeInsets.zero,
      controller: controller,
      style: TextStyles.headline16(context),
      decoration: getInputDecotration(
        context,
      ),
      readOnly: readOnly,
      validator: (val) => KValidator.buildValidators(
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
      decoration: BoxDecorations.outlineBorder(context, radius: 10, width: 1)
          .copyWith(
              color: !readOnly
                  ? context.onPrimary
                  : context.disabledColor.withOpacity(.07)),
      padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: TextStyles.subtitle14(context)),
          SizedBox(child: field(context, dartz.none()))
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
