part of 'athlete_bloc.dart';

enum AthleteStatus { initial, loading, loaded, submitting, success, error }

class AthleteState extends Equatable {
  final AthleteStatus status;
  final List<AthleteModel> athletes;
  final String? searchQuery;
  final String? errorMessage;
  final String? successMessage;

  const AthleteState({
    this.status = AthleteStatus.initial,
    this.athletes = const [],
    this.searchQuery,
    this.errorMessage,
    this.successMessage,
  });

  const AthleteState.initial() : this();

  AthleteState copyWith({
    AthleteStatus? status,
    List<AthleteModel>? athletes,
    String? searchQuery,
    String? errorMessage,
    String? successMessage,
  }) {
    return AthleteState(
      status: status ?? this.status,
      athletes: athletes ?? this.athletes,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  bool get isLoading => status == AthleteStatus.loading;
  bool get isSubmitting => status == AthleteStatus.submitting;
  bool get isSuccess => status == AthleteStatus.success;
  bool get hasError => status == AthleteStatus.error;

  @override
  List<Object?> get props => [status, athletes, searchQuery, errorMessage, successMessage];
}
