import 'package:animel_core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/localization/logic/locale_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/logic/theme_bloc.dart';
import 'features/home/logic/animal_bloc.dart';
import 'features/adoption/logic/adoption_bloc.dart';
import 'features/shop/logic/shop_bloc.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'features/chat/logic/chat_bloc.dart';

class AnimalConnectApp extends StatelessWidget {
  const AnimalConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(LoadThemePreference()),
        ),
        BlocProvider(
          create: (context) => LocaleBloc()..add(LoadLocalePreference()),
        ),
        BlocProvider(create: (context) => AuthBloc()..add(AppStarted())),
        BlocProvider(create: (context) => AnimalBloc()),
        BlocProvider(create: (context) => AdoptionBloc()),
        BlocProvider(create: (context) => ShopBloc()),
        BlocProvider(create: (context) => ChatBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Animal Connect',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                locale: localeState.locale,
                routerConfig: AppRouter.router,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('ar')],
              );
            },
          );
        },
      ),
    );
  }
}
