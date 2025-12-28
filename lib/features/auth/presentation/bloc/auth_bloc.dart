import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Bloc pour gérer l'authentification
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final DioClient _dioClient;

  AuthBloc({
    required AuthRepository authRepository,
    required DioClient dioClient,
  })  : _authRepository = authRepository,
        _dioClient = dioClient,
        super(const AuthState.initial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthErrorCleared>(_onErrorCleared);
  }

  /// Vérifier l'état d'authentification au démarrage
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final isAuthenticated = await _authRepository.isAuthenticated();
    
    if (!isAuthenticated) {
      emit(const AuthState.unauthenticated());
      return;
    }

    // Récupérer le token et le configurer dans Dio
    final token = await _authRepository.getToken();
    if (token != null) {
      _dioClient.setAuthToken(token);
    }

    // Récupérer l'utilisateur
    final result = await _authRepository.getCurrentUser();
    
    result.fold(
      (failure) {
        emit(const AuthState.unauthenticated());
      },
      (user) {
        emit(AuthState.authenticated(user));
      },
    );
  }

  /// Connexion
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _authRepository.login(event.email, event.password);

    await result.fold(
      (failure) {
        emit(AuthState.error(failure.message));
      },
      (user) async {
        // Configurer le token dans DioClient après connexion réussie
        final token = await _authRepository.getToken();
        if (token != null) {
          _dioClient.setAuthToken(token);
        }
        emit(AuthState.authenticated(user));
      },
    );
  }

  /// Déconnexion
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    await _authRepository.logout();
    _dioClient.setAuthToken(null);

    emit(const AuthState.unauthenticated());
  }

  /// Mot de passe oublié
  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Garder l'état actuel mais indiquer le chargement
    final currentState = state;
    emit(currentState.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.forgotPassword(event.email);

    result.fold(
      (failure) {
        emit(AuthState.error(failure.message));
      },
      (_) {
        // Revenir à l'état non authentifié après succès
        emit(const AuthState.unauthenticated());
      },
    );
  }

  /// Effacer l'erreur
  void _onErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.unauthenticated());
  }
}
