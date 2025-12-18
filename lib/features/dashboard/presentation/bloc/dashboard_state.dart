part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardResponse? data;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.data,
    this.errorMessage,
  });

  const DashboardState.initial() : this();

  const DashboardState.loading() : this(status: DashboardStatus.loading);

  const DashboardState.loaded(DashboardResponse data)
      : this(status: DashboardStatus.loaded, data: data);

  const DashboardState.error(String message)
      : this(status: DashboardStatus.error, errorMessage: message);

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardResponse? data,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == DashboardStatus.loading;
  bool get isLoaded => status == DashboardStatus.loaded;
  bool get hasError => status == DashboardStatus.error;

  @override
  List<Object?> get props => [status, data, errorMessage];
}
