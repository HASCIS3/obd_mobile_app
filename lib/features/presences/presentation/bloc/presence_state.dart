part of 'presence_bloc.dart';

enum PresenceStatus { initial, loading, loaded, submitting, success, error }

class PresenceState extends Equatable {
  final PresenceStatus status;
  final List<PresenceModel> presences;
  final String? errorMessage;
  final String? successMessage;

  const PresenceState({
    this.status = PresenceStatus.initial,
    this.presences = const [],
    this.errorMessage,
    this.successMessage,
  });

  const PresenceState.initial() : this();

  PresenceState copyWith({
    PresenceStatus? status,
    List<PresenceModel>? presences,
    String? errorMessage,
    String? successMessage,
  }) {
    return PresenceState(
      status: status ?? this.status,
      presences: presences ?? this.presences,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  bool get isLoading => status == PresenceStatus.loading;
  bool get isSubmitting => status == PresenceStatus.submitting;
  bool get isSuccess => status == PresenceStatus.success;

  @override
  List<Object?> get props => [status, presences, errorMessage, successMessage];
}
