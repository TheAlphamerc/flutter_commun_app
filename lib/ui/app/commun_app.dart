import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_commun_app/cubit/app/app_cubit.dart';
import 'package:flutter_commun_app/locator.dart';
import 'package:flutter_commun_app/resource/repository/auth/auth_repo.dart';
import 'package:flutter_commun_app/resource/repository/profile/profile_repo.dart';
import 'package:flutter_commun_app/resource/service/navigation/navigation_service.dart';
import 'package:flutter_commun_app/ui/pages/app_start/welcome/onboard_page.dart';
import 'package:flutter_commun_app/ui/pages/home/home_page.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunApp extends StatefulWidget {
  final Widget home;

  const CommunApp({
    Key? key,
    required this.home,
  }) : super(key: key);

  @override
  _PensilAppState createState() => _PensilAppState();
}

void listener(BuildContext context, AppState state) {
  state.maybeWhen(
    orElse: () {},
    response: (estate, message) {
      estate.mayBeWhen(elseMaybe: () {
        getIt<NavigationService>()
            .pushAndRemoveUntil<Route<void>>(GetStartedPage.getRoute());
      }, loggedIn: () {
        getIt<NavigationService>()
            .pushAndRemoveUntil<Route<void>>(HomePage.getRoute());
      });
    },
  );
}

class _PensilAppState extends State<CommunApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (_) => AppCubit(getIt<AuthRepo>(), getIt<ProfileRepo>())
        ..checkAuthentication(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: listener,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: widget.home,
            theme: AppTheme.lightTheme.copyWith(
              textTheme: GoogleFonts.sourceSansProTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            locale: const Locale('en', ''),
            navigatorKey: getIt<NavigationService>().navigatorKey,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (BuildContext context) => "Commun",
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}
