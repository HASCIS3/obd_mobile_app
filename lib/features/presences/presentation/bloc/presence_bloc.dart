import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/presence_model.dart';
import '../../domain/repositories/presence_repository.dart';

part 'presence_event.dart';
part 'presence_state.dart';

class PresenceBloc extends Bloc<PresenceEvent, PresenceState> {
  final PresenceRepository _repository;

  PresenceBloc({required PresenceRepository repository})
      : _repository = repository,
        super(const PresenceState.initial()) {
    on<PresenceLoadRequested>(_onLoadRequested);
    on<PresenceRefreshRequested>(_onRefreshRequested);
    on<PresenceCreateRequested>(_onCreateRequested);
    on<PresenceUpdateRequested>(_onUpdateRequested);
    on<PresenceDeleteRequested>(_onDeleteRequested);
    on<PresencePointageMasseRequested>(_onPointageMasseRequested);
  }

  Future<void> _onLoadRequested(
    PresenceLoadRequested event,
    Emitter<PresenceState> emit,
  ) async {
    emit(state.copyWith(status: PresenceStatus.loading));

    final result = await _repository.getPresences(
      athleteId: event.athleteId,
      date: event.date,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PresenceStatus.error,
        errorMessage: failure.message,
      )),
      (presences) => emit(state.copyWith(
        status: PresenceStatus.loaded,
        presences: presences,
      )),
    );
  }

  Future<void> _onRefreshRequested(
    PresenceRefreshRequested event,
    Emitter<PresenceState> emit,
  ) async {
    final result = await _repository.getPresences();

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (presences) => emit(state.copyWith(
        status: PresenceStatus.loaded,
        presences: presences,
      )),
    );
  }

  Future<void> _onCreateRequested(
    PresenceCreateRequested event,
    Emitter<PresenceState> emit,
  ) async {
    emit(state.copyWith(status: PresenceStatus.submitting));

    final result = await _repository.createPresence(event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PresenceStatus.error,
        errorMessage: failure.message,
      )),
      (presence) {
        final updatedList = [presence, ...state.presences];
        emit(state.copyWith(
          status: PresenceStatus.success,
          presences: updatedList,
          successMessage: 'Présence enregistrée',
        ));
      },
    );
  }

  Future<void> _onUpdateRequested(
    PresenceUpdateRequested event,
    Emitter<PresenceState> emit,
  ) async {
    emit(state.copyWith(status: PresenceStatus.submitting));

    final result = await _repository.updatePresence(event.id, event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PresenceStatus.error,
        errorMessage: failure.message,
      )),
      (presence) {
        final updatedList = state.presences.map((p) {
          return p.id == event.id ? presence : p;
        }).toList();
        emit(state.copyWith(
          status: PresenceStatus.success,
          presences: updatedList,
          successMessage: 'Présence modifiée',
        ));
      },
    );
  }

  Future<void> _onDeleteRequested(
    PresenceDeleteRequested event,
    Emitter<PresenceState> emit,
  ) async {
    emit(state.copyWith(status: PresenceStatus.submitting));

    final result = await _repository.deletePresence(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PresenceStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedList = state.presences.where((p) => p.id != event.id).toList();
        emit(state.copyWith(
          status: PresenceStatus.success,
          presences: updatedList,
          successMessage: 'Présence supprimée',
        ));
      },
    );
  }

  Future<void> _onPointageMasseRequested(
    PresencePointageMasseRequested event,
    Emitter<PresenceState> emit,
  ) async {
    emit(state.copyWith(status: PresenceStatus.submitting));

    final result = await _repository.pointageMasse(event.presences);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PresenceStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: PresenceStatus.success,
        successMessage: 'Pointage enregistré avec succès',
      )),
    );
  }
}
