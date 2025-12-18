part of 'discipline_bloc.dart';

enum DisciplineStatus { initial, loading, loaded, error }

class DisciplineState extends Equatable {
  final DisciplineStatus status;
  final List<DisciplineModel> disciplines;
  final String? errorMessage;

  const DisciplineState({
    this.status = DisciplineStatus.initial,
    this.disciplines = const [],
    this.errorMessage,
  });

  const DisciplineState.initial() : this();

  DisciplineState copyWith({
    DisciplineStatus? status,
    List<DisciplineModel>? disciplines,
    String? errorMessage,
  }) {
    return DisciplineState(
      status: status ?? this.status,
      disciplines: disciplines ?? this.disciplines,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == DisciplineStatus.loading;

  @override
  List<Object?> get props => [status, disciplines, errorMessage];
}
