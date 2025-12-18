part of 'paiement_bloc.dart';

enum PaiementStatus { initial, loading, loaded, submitting, success, error }

class PaiementState extends Equatable {
  final PaiementStatus status;
  final List<PaiementModel> paiements;
  final String? errorMessage;
  final String? successMessage;

  const PaiementState({
    this.status = PaiementStatus.initial,
    this.paiements = const [],
    this.errorMessage,
    this.successMessage,
  });

  const PaiementState.initial() : this();

  PaiementState copyWith({
    PaiementStatus? status,
    List<PaiementModel>? paiements,
    String? errorMessage,
    String? successMessage,
  }) {
    return PaiementState(
      status: status ?? this.status,
      paiements: paiements ?? this.paiements,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  bool get isLoading => status == PaiementStatus.loading;
  bool get isSubmitting => status == PaiementStatus.submitting;
  bool get isSuccess => status == PaiementStatus.success;

  @override
  List<Object?> get props => [status, paiements, errorMessage, successMessage];
}
