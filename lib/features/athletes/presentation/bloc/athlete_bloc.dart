import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/athlete_model.dart';
import '../../domain/repositories/athlete_repository.dart';

part 'athlete_event.dart';
part 'athlete_state.dart';

class AthleteBloc extends Bloc<AthleteEvent, AthleteState> {
  final AthleteRepository _repository;

  AthleteBloc({required AthleteRepository repository})
      : _repository = repository,
        super(const AthleteState.initial()) {
    on<AthleteLoadRequested>(_onLoadRequested);
    on<AthleteRefreshRequested>(_onRefreshRequested);
    on<AthleteSearchChanged>(_onSearchChanged);
    on<AthleteCreateRequested>(_onCreateRequested);
    on<AthleteUpdateRequested>(_onUpdateRequested);
    on<AthleteDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onLoadRequested(
    AthleteLoadRequested event,
    Emitter<AthleteState> emit,
  ) async {
    emit(state.copyWith(status: AthleteStatus.loading));

    final result = await _repository.getAthletes(
      search: state.searchQuery,
      actif: event.actifOnly ? true : null,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AthleteStatus.error,
        errorMessage: failure.message,
      )),
      (athletes) => emit(state.copyWith(
        status: AthleteStatus.loaded,
        athletes: athletes,
      )),
    );
  }

  Future<void> _onRefreshRequested(
    AthleteRefreshRequested event,
    Emitter<AthleteState> emit,
  ) async {
    final result = await _repository.getAthletes(search: state.searchQuery);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (athletes) => emit(state.copyWith(
        status: AthleteStatus.loaded,
        athletes: athletes,
      )),
    );
  }

  Future<void> _onSearchChanged(
    AthleteSearchChanged event,
    Emitter<AthleteState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, status: AthleteStatus.loading));

    final result = await _repository.getAthletes(search: event.query);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AthleteStatus.error,
        errorMessage: failure.message,
      )),
      (athletes) => emit(state.copyWith(
        status: AthleteStatus.loaded,
        athletes: athletes,
      )),
    );
  }

  Future<void> _onCreateRequested(
    AthleteCreateRequested event,
    Emitter<AthleteState> emit,
  ) async {
    emit(state.copyWith(status: AthleteStatus.submitting));

    final result = await _repository.createAthlete(event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AthleteStatus.error,
        errorMessage: failure.message,
      )),
      (athlete) {
        final updatedList = [athlete, ...state.athletes];
        emit(state.copyWith(
          status: AthleteStatus.success,
          athletes: updatedList,
          successMessage: 'Athlète créé avec succès',
        ));
      },
    );
  }

  Future<void> _onUpdateRequested(
    AthleteUpdateRequested event,
    Emitter<AthleteState> emit,
  ) async {
    emit(state.copyWith(status: AthleteStatus.submitting));

    final result = await _repository.updateAthlete(event.id, event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AthleteStatus.error,
        errorMessage: failure.message,
      )),
      (athlete) {
        final updatedList = state.athletes.map((a) {
          return a.id == event.id ? athlete : a;
        }).toList();
        emit(state.copyWith(
          status: AthleteStatus.success,
          athletes: updatedList,
          successMessage: 'Athlète modifié avec succès',
        ));
      },
    );
  }

  Future<void> _onDeleteRequested(
    AthleteDeleteRequested event,
    Emitter<AthleteState> emit,
  ) async {
    emit(state.copyWith(status: AthleteStatus.submitting));

    final result = await _repository.deleteAthlete(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AthleteStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedList = state.athletes.where((a) => a.id != event.id).toList();
        emit(state.copyWith(
          status: AthleteStatus.success,
          athletes: updatedList,
          successMessage: 'Athlète supprimé avec succès',
        ));
      },
    );
  }
}
