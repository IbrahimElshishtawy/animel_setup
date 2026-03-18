import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final Map<String, dynamic> userData;
  const RegisterRequested(this.userData);
  @override
  List<Object> get props => [userData];
}

class LogoutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final UserProfile user;
  const Authenticated(this.user);
  @override
  List<Object> get props => [user];
}
class Unauthenticated extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await _authRepository.login(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthFailure('Login failed. Please check your credentials.'));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await _authRepository.register(event.userData);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthFailure('Registration failed. Please try again.'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await _authRepository.logout();
      emit(Unauthenticated());
    });
  }
}
