part of 'auth_bloc.dart';

/// États d'authentification
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// État d'authentification
class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// État initial
  const AuthState.initial() : this();

  /// État de chargement
  const AuthState.loading()
      : this(status: AuthStatus.loading);

  /// État authentifié
  const AuthState.authenticated(UserModel user)
      : this(status: AuthStatus.authenticated, user: user);

  /// État non authentifié
  const AuthState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  /// État d'erreur
  const AuthState.error(String message)
      : this(status: AuthStatus.error, errorMessage: message);

  /// Copie avec modifications
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Vérifie si l'utilisateur est authentifié
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Vérifie si le chargement est en cours
  bool get isLoading => status == AuthStatus.loading;

  /// Vérifie si c'est un admin
  bool get isAdmin => user?.isAdmin ?? false;

  /// Vérifie si c'est un coach
  bool get isCoach => user?.isCoach ?? false;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
