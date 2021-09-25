import 'package:flutter/material.dart';
import 'package:flutter_commun_app/helper/images.dart';
import 'package:flutter_commun_app/helper/utility.dart';
import 'package:flutter_commun_app/ui/pages/app_start/sign_in/continue_with_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/k_button.dart';
import 'package:flutter_commun_app/ui/widget/page_indicator.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  static Route<T> getRoute<T>() {
    return MaterialPageRoute(
      builder: (_) => const GetStartedPage(),
    );
  }

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  late PageController controller;
  String? buttonText;
  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    switch (controller.page!.toInt()) {
      case 0:
        controller.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInSine);
        break;
      case 1:
        controller.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInSine);
        break;

      case 2:
        Utility.cprint("Navigate to Sign");
        Navigator.push(context, ContinueWithPage.getRoute());
        break;

      default:
    }
  }

  Widget _form(BuildContext context) {
    return Container(
      width: context.width - 16,
      margin: const EdgeInsets.symmetric(vertical: 16) +
          const EdgeInsets.only(top: 32),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            SizedBox(
              height: context.height * .7,
              child: PageView.builder(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                itemCount: 3,
                onPageChanged: (page) {
                  setState(() {
                    buttonText =
                        page < 2 ? context.locale.next : context.locale.signIn;
                  });
                },
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const Slider1();
                    case 1:
                      return const Slider2();
                    case 2:
                      return const Slider3();

                    default:
                      return const Slider1();
                  }
                },
              ),
            ),
            DotsIndicator(
              controller: controller,
              itemCount: 3,
              color: context.primaryColor,
            ).pV(24),
            // const SizedBox(height: 14),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: KFlatButton(
                  label: buttonText ?? context.locale.next,
                  labelStyle: TextStyles.headline18(context)
                      .copyWith(color: context.onPrimary, fontSize: 20),
                  isLoading: isLoading,
                  borderRadius: 100,
                  onPressed: () {
                    _submit(context);
                  },
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        child: SafeArea(
          top: false,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _form(context),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Slider1 extends StatelessWidget {
  const Slider1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.onBoardPicOne, height: height * .4).pB(30),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyles.headline36(context)
                  .copyWith(fontWeight: FontWeight.w500),
              children: [
                TextSpan(text: context.locale.welcometo),
                TextSpan(
                  text: " ${context.locale.appName} /",
                  style: TextStyles.headline36(context)
                      .copyWith(
                        fontWeight: FontWeight.w800,
                      )
                      .primary(context),
                ),
              ],
            ),
          ).pB(25),
          Text(context.locale.onboardWelcomeOne,
                  style: TextStyles.headline18(context),
                  textAlign: TextAlign.center)
              .pH(21)
        ],
      ),
    );
  }
}

class Slider2 extends StatelessWidget {
  const Slider2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.onBoardPicTwo, height: height * .4).pB(30),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyles.headline36(context).copyWith(
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(text: context.locale.allInOne),
                TextSpan(
                  text: "\n${context.locale.socialNetwork}",
                  style: TextStyles.headline36(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ).pB(25),
          Text(context.locale.onboardWelcomeTwo,
                  style: TextStyles.headline18(context),
                  textAlign: TextAlign.center)
              .pH(21)
        ],
      ),
    );
  }
}

class Slider3 extends StatelessWidget {
  const Slider3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.onBoardPicFour, height: height * .4).pB(30),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyles.headline36(context).copyWith(
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(text: context.locale.owned),
                TextSpan(
                  text: " ${context.locale.byUsers}",
                  style: TextStyles.headline36(context).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ).pB(25),
          Text(
            context.locale.onboardWelcomeThree,
            style: TextStyles.headline18(context),
            textAlign: TextAlign.center,
          ).pH(21)
        ],
      ),
    );
  }
}
