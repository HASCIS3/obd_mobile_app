import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/dashboard_stats_model.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc({required DashboardRepository repository})
      : _repository = repository,
        super(const DashboardState.initial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardState.loading());

    final result = await _repository.getDashboard();

    result.fold(
      (failure) => emit(DashboardState.error(failure.message)),
      (response) => emit(DashboardState.loaded(response)),
    );
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await _repository.getDashboard();

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (response) => emit(DashboardState.loaded(response)),
    );
  }
}
