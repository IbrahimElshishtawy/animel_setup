import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/user_journey.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';
import '../../../core/services/storage_service.dart';

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

class JourneyUpdated extends AuthEvent {
  final UserJourney journey;

  const JourneyUpdated(this.journey);

  @override
  List<Object?> get props => [journey];
}

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
  final UserJourney? journey;
  final bool hasCompletedJourney;
  final String? message;

  const Authenticated(
    this.user, {
    this.journey,
    this.hasCompletedJourney = false,
    this.message,
  });

  @override
  List<Object?> get props => [user, journey, hasCompletedJourney, message];
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
  final StorageService _storageService = StorageService();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<ProfileUpdated>(_onProfileUpdated);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
    on<JourneyUpdated>(_onJourneyUpdated);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<Authenticated> _buildAuthenticatedState(
    UserProfile user, {
    String? message,
  }) async {
    final storedJourney = await _storageService.getUserJourney(user.id);
    final journey = UserJourneyX.fromStorage(storedJourney);
    return Authenticated(
      user,
      journey: journey,
      hasCompletedJourney: journey != null,
      message: message,
    );
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      emit(await _buildAuthenticatedState(user));
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
      emit(await _buildAuthenticatedState(user));
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
      emit(await _buildAuthenticatedState(user));
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
      emit(
        await _buildAuthenticatedState(
          updatedUser,
          message: 'Profile updated successfully',
        ),
      );
    } catch (error) {
      emit(AuthFailure(error.toString().replaceFirst('ApiException: ', '')));
      emit(
        Authenticated(
          currentState.user,
          journey: currentState.journey,
          hasCompletedJourney: currentState.hasCompletedJourney,
        ),
      );
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
        emit(await _buildAuthenticatedState(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(
        Authenticated(
          currentState.user,
          journey: currentState.journey,
          hasCompletedJourney: currentState.hasCompletedJourney,
        ),
      );
    }
  }

  Future<void> _onJourneyUpdated(
    JourneyUpdated event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! Authenticated) return;

    await _storageService.saveUserJourney(
      currentState.user.id,
      event.journey.storageValue,
    );
    emit(
      Authenticated(
        currentState.user,
        journey: event.journey,
        hasCompletedJourney: true,
      ),
    );
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
