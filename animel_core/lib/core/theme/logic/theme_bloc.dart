import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class LoadThemePreference extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class SetThemeMode extends ThemeEvent {
  const SetThemeMode(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}

class ThemeState extends Equatable {
  const ThemeState(this.themeMode, {this.isLoaded = false});

  final ThemeMode themeMode;
  final bool isLoaded;

  @override
  List<Object> get props => [themeMode, isLoaded];
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.light)) {
    on<LoadThemePreference>(_onLoadThemePreference);
    on<ToggleTheme>(_onToggleTheme);
    on<SetThemeMode>(_onSetThemeMode);
  }

  static const _preferenceKey = 'theme_mode';

  Future<void> _onLoadThemePreference(
    LoadThemePreference event,
    Emitter<ThemeState> emit,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final storedMode = preferences.getString(_preferenceKey);

    emit(
      ThemeState(
        switch (storedMode) {
          'dark' => ThemeMode.dark,
          'system' => ThemeMode.system,
          _ => ThemeMode.light,
        },
        isLoaded: true,
      ),
    );
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    await _persistThemeMode(nextMode);
    emit(ThemeState(nextMode, isLoaded: true));
  }

  Future<void> _onSetThemeMode(
    SetThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    await _persistThemeMode(event.themeMode);
    emit(ThemeState(event.themeMode, isLoaded: true));
  }

  Future<void> _persistThemeMode(ThemeMode themeMode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _preferenceKey,
      switch (themeMode) {
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
        ThemeMode.light => 'light',
      },
    );
  }
}
