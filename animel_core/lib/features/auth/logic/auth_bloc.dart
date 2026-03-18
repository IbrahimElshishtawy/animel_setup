import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final Map<String, dynamic> userData;

  const RegisterRequested(this.userData);

  @override
  List<Object?> get props => [userData];
}

class ProfileUpdated extends AuthEvent {
  final Map<String, dynamic> data;

  const ProfileUpdated(this.data);

  @override
  List<Object?> get props => [data];
}

class ProfileRefreshRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserProfile user;
  final String? message;

  const Authenticated(this.user, {this.message});

  @override
  List<Object?> get props => [user, message];
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<ProfileUpdated>(_onProfileUpdated);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(event.email, event.password);
      emit(Authenticated(user));
    } catch (error) {
      emit(AuthFailure(error.toString().replaceFirst('ApiException: ', '')));
      emit(Unauthenticated());
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.register(event.userData);
      emit(Authenticated(user));
    } catch (error) {
      emit(AuthFailure(error.toString().replaceFirst('ApiException: ', '')));
      emit(Unauthenticated());
    }
  }

  Future<void> _onProfileUpdated(
    ProfileUpdated event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! Authenticated) return;

    emit(AuthLoading());
    try {
      final updatedUser = await _authRepository.updateProfile(event.data);
      emit(Authenticated(updatedUser, message: 'Profile updated successfully'));
    } catch (error) {
      emit(AuthFailure(error.toString().replaceFirst('ApiException: ', '')));
      emit(Authenticated(currentState.user));
    }
  }

  Future<void> _onProfileRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! Authenticated) return;

    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Authenticated(currentState.user));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
