part of 'performance_bloc.dart';

enum PerformanceStatus { initial, loading, loaded, submitting, success, error }

class PerformanceState extends Equatable {
  final PerformanceStatus status;
  final List<PerformanceModel> performances;
  final String? errorMessage;
  final String? successMessage;

  const PerformanceState({
    this.status = PerformanceStatus.initial,
    this.performances = const [],
    this.errorMessage,
    this.successMessage,
  });

  const PerformanceState.initial() : this();

  PerformanceState copyWith({
    PerformanceStatus? status,
    List<PerformanceModel>? performances,
    String? errorMessage,
    String? successMessage,
  }) {
    return PerformanceState(
      status: status ?? this.status,
      performances: performances ?? this.performances,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  bool get isLoading => status == PerformanceStatus.loading;
  bool get isSubmitting => status == PerformanceStatus.submitting;
  bool get isSuccess => status == PerformanceStatus.success;

  @override
  List<Object?> get props => [status, performances, errorMessage, successMessage];
}
