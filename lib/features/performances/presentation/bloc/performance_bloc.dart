import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/performance_model.dart';
import '../../domain/repositories/performance_repository.dart';

part 'performance_event.dart';
part 'performance_state.dart';

class PerformanceBloc extends Bloc<PerformanceEvent, PerformanceState> {
  final PerformanceRepository _repository;

  PerformanceBloc({required PerformanceRepository repository})
      : _repository = repository,
        super(const PerformanceState.initial()) {
    on<PerformanceLoadRequested>(_onLoadRequested);
    on<PerformanceRefreshRequested>(_onRefreshRequested);
    on<PerformanceCreateRequested>(_onCreateRequested);
    on<PerformanceUpdateRequested>(_onUpdateRequested);
    on<PerformanceDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    PerformanceLoadRequested event,
    Emitter<PerformanceState> emit,
  ) async {
    emit(state.copyWith(status: PerformanceStatus.loading));

    final result = await _repository.getPerformances(athleteId: event.athleteId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PerformanceStatus.error,
        errorMessage: failure.message,
      )),
      (performances) => emit(state.copyWith(
        status: PerformanceStatus.loaded,
        performances: performances,
      )),
    );
  }

  Future<void> _onRefreshRequested(
    PerformanceRefreshRequested event,
    Emitter<PerformanceState> emit,
  ) async {
    final result = await _repository.getPerformances();

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (performances) => emit(state.copyWith(
        status: PerformanceStatus.loaded,
        performances: performances,
      )),
    );
  }

  Future<void> _onCreateRequested(
    PerformanceCreateRequested event,
    Emitter<PerformanceState> emit,
  ) async {
    emit(state.copyWith(status: PerformanceStatus.submitting));

    final result = await _repository.createPerformance(event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PerformanceStatus.error,
        errorMessage: failure.message,
      )),
      (performance) {
        final updatedList = [performance, ...state.performances];
        emit(state.copyWith(
          status: PerformanceStatus.success,
          performances: updatedList,
          successMessage: 'Performance enregistrée',
        ));
      },
    );
  }

  Future<void> _onUpdateRequested(
    PerformanceUpdateRequested event,
    Emitter<PerformanceState> emit,
  ) async {
    emit(state.copyWith(status: PerformanceStatus.submitting));

    final result = await _repository.updatePerformance(event.id, event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PerformanceStatus.error,
        errorMessage: failure.message,
      )),
      (performance) {
        final updatedList = state.performances.map((p) {
          return p.id == event.id ? performance : p;
        }).toList();
        emit(state.copyWith(
          status: PerformanceStatus.success,
          performances: updatedList,
          successMessage: 'Performance modifiée',
        ));
      },
    );
  }

  Future<void> _onDeleteRequested(
    PerformanceDeleteRequested event,
    Emitter<PerformanceState> emit,
  ) async {
    emit(state.copyWith(status: PerformanceStatus.submitting));

    final result = await _repository.deletePerformance(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PerformanceStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedList = state.performances.where((p) => p.id != event.id).toList();
        emit(state.copyWith(
          status: PerformanceStatus.success,
          performances: updatedList,
          successMessage: 'Performance supprimée',
        ));
      },
    );
  }
}
