import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/paiement_model.dart';
import '../../domain/repositories/paiement_repository.dart';

part 'paiement_event.dart';
part 'paiement_state.dart';

class PaiementBloc extends Bloc<PaiementEvent, PaiementState> {
  final PaiementRepository _repository;

  PaiementBloc({required PaiementRepository repository})
      : _repository = repository,
        super(const PaiementState.initial()) {
    on<PaiementLoadRequested>(_onLoadRequested);
    on<PaiementRefreshRequested>(_onRefreshRequested);
    on<PaiementCreateRequested>(_onCreateRequested);
    on<PaiementUpdateRequested>(_onUpdateRequested);
    on<PaiementDeleteRequested>(_onDeleteRequested);
    on<PaiementArrieresRequested>(_onArrieresRequested);
  }

  Future<void> _onLoadRequested(
    PaiementLoadRequested event,
    Emitter<PaiementState> emit,
  ) async {
    emit(state.copyWith(status: PaiementStatus.loading));

    final result = await _repository.getPaiements(
      athleteId: event.athleteId,
      mois: event.mois,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaiementStatus.error,
        errorMessage: failure.message,
      )),
      (paiements) => emit(state.copyWith(
        status: PaiementStatus.loaded,
        paiements: paiements,
      )),
    );
  }

  Future<void> _onRefreshRequested(
    PaiementRefreshRequested event,
    Emitter<PaiementState> emit,
  ) async {
    final result = await _repository.getPaiements();

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (paiements) => emit(state.copyWith(
        status: PaiementStatus.loaded,
        paiements: paiements,
      )),
    );
  }

  Future<void> _onCreateRequested(
    PaiementCreateRequested event,
    Emitter<PaiementState> emit,
  ) async {
    emit(state.copyWith(status: PaiementStatus.submitting));

    final result = await _repository.createPaiement(event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaiementStatus.error,
        errorMessage: failure.message,
      )),
      (paiement) {
        final updatedList = [paiement, ...state.paiements];
        emit(state.copyWith(
          status: PaiementStatus.success,
          paiements: updatedList,
          successMessage: 'Paiement enregistré avec succès',
        ));
      },
    );
  }

  Future<void> _onUpdateRequested(
    PaiementUpdateRequested event,
    Emitter<PaiementState> emit,
  ) async {
    emit(state.copyWith(status: PaiementStatus.submitting));

    final result = await _repository.updatePaiement(event.id, event.data);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaiementStatus.error,
        errorMessage: failure.message,
      )),
      (paiement) {
        final updatedList = state.paiements.map((p) {
          return p.id == event.id ? paiement : p;
        }).toList();
        emit(state.copyWith(
          status: PaiementStatus.success,
          paiements: updatedList,
          successMessage: 'Paiement modifié avec succès',
        ));
      },
    );
  }

  Future<void> _onDeleteRequested(
    PaiementDeleteRequested event,
    Emitter<PaiementState> emit,
  ) async {
    emit(state.copyWith(status: PaiementStatus.submitting));

    final result = await _repository.deletePaiement(event.id);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaiementStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedList = state.paiements.where((p) => p.id != event.id).toList();
        emit(state.copyWith(
          status: PaiementStatus.success,
          paiements: updatedList,
          successMessage: 'Paiement supprimé avec succès',
        ));
      },
    );
  }

  Future<void> _onArrieresRequested(
    PaiementArrieresRequested event,
    Emitter<PaiementState> emit,
  ) async {
    emit(state.copyWith(status: PaiementStatus.loading));

    final result = await _repository.getArrieres();

    result.fold(
      (failure) => emit(state.copyWith(
        status: PaiementStatus.error,
        errorMessage: failure.message,
      )),
      (arrieres) => emit(state.copyWith(
        status: PaiementStatus.loaded,
        paiements: arrieres,
      )),
    );
  }
}
