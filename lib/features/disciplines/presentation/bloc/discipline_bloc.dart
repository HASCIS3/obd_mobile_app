import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/discipline_model.dart';
import '../../domain/repositories/discipline_repository.dart';

part 'discipline_event.dart';
part 'discipline_state.dart';

class DisciplineBloc extends Bloc<DisciplineEvent, DisciplineState> {
  final DisciplineRepository _repository;

  DisciplineBloc({required DisciplineRepository repository})
      : _repository = repository,
        super(const DisciplineState.initial()) {
    on<DisciplineLoadRequested>(_onLoadRequested);
    on<DisciplineRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    DisciplineLoadRequested event,
    Emitter<DisciplineState> emit,
  ) async {
    emit(state.copyWith(status: DisciplineStatus.loading));

    final result = await _repository.getDisciplines();

    result.fold(
      (failure) => emit(state.copyWith(
        status: DisciplineStatus.error,
        errorMessage: failure.message,
      )),
      (disciplines) => emit(state.copyWith(
        status: DisciplineStatus.loaded,
        disciplines: disciplines,
      )),
    );
  }

  Future<void> _onRefreshRequested(
    DisciplineRefreshRequested event,
    Emitter<DisciplineState> emit,
  ) async {
    final result = await _repository.getDisciplines();

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (disciplines) => emit(state.copyWith(
        status: DisciplineStatus.loaded,
        disciplines: disciplines,
      )),
    );
  }
}
