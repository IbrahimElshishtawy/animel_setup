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
import 'features/favorites/logic/favorites_cubit.dart';

class AnimalConnectApp extends StatefulWidget {
  const AnimalConnectApp({super.key});

  @override
  State<AnimalConnectApp> createState() => _AnimalConnectAppState();
}

class _AnimalConnectAppState extends State<AnimalConnectApp> {
  late final ThemeBloc _themeBloc;
  late final LocaleBloc _localeBloc;
  late final AuthBloc _authBloc;
  late final AnimalBloc _animalBloc;
  late final AdoptionBloc _adoptionBloc;
  late final ShopBloc _shopBloc;
  late final ChatBloc _chatBloc;
  late final FavoritesCubit _favoritesCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc()..add(LoadThemePreference());
    _localeBloc = LocaleBloc()..add(LoadLocalePreference());
    _authBloc = AuthBloc()..add(AppStarted());
    _animalBloc = AnimalBloc();
    _adoptionBloc = AdoptionBloc();
    _shopBloc = ShopBloc();
    _chatBloc = ChatBloc();
    _favoritesCubit = FavoritesCubit()..loadFavorites();
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _appRouter.dispose();
    _chatBloc.close();
    _favoritesCubit.close();
    _shopBloc.close();
    _adoptionBloc.close();
    _animalBloc.close();
    _authBloc.close();
    _localeBloc.close();
    _themeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _themeBloc),
        BlocProvider.value(value: _localeBloc),
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _animalBloc),
        BlocProvider.value(value: _adoptionBloc),
        BlocProvider.value(value: _shopBloc),
        BlocProvider.value(value: _chatBloc),
        BlocProvider.value(value: _favoritesCubit),
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
                routerConfig: _appRouter.router,
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
