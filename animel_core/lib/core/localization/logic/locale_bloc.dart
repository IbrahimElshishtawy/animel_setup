import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocalePreference extends LocaleEvent {}

class SetLocalePreference extends LocaleEvent {
  const SetLocalePreference(this.languageCode);

  final String? languageCode;

  @override
  List<Object?> get props => [languageCode];
}

class LocaleState extends Equatable {
  const LocaleState({this.locale, this.isLoaded = false});

  final Locale? locale;
  final bool isLoaded;

  @override
  List<Object?> get props => [locale, isLoaded];
}

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState()) {
    on<LoadLocalePreference>(_onLoadLocalePreference);
    on<SetLocalePreference>(_onSetLocalePreference);
  }

  static const _preferenceKey = 'locale_code';

  Future<void> _onLoadLocalePreference(
    LoadLocalePreference event,
    Emitter<LocaleState> emit,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_preferenceKey);

    emit(
      LocaleState(
        locale: languageCode == null ? null : Locale(languageCode),
        isLoaded: true,
      ),
    );
  }

  Future<void> _onSetLocalePreference(
    SetLocalePreference event,
    Emitter<LocaleState> emit,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    if (event.languageCode == null || event.languageCode!.isEmpty) {
      await preferences.remove(_preferenceKey);
      emit(const LocaleState(locale: null, isLoaded: true));
      return;
    }

    await preferences.setString(_preferenceKey, event.languageCode!);
    emit(LocaleState(locale: Locale(event.languageCode!), isLoaded: true));
  }
}
