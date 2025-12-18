part of 'paiement_bloc.dart';

abstract class PaiementEvent extends Equatable {
  const PaiementEvent();

  @override
  List<Object?> get props => [];
}

class PaiementLoadRequested extends PaiementEvent {
  final int? athleteId;
  final String? mois;

  const PaiementLoadRequested({this.athleteId, this.mois});

  @override
  List<Object?> get props => [athleteId, mois];
}

class PaiementRefreshRequested extends PaiementEvent {
  const PaiementRefreshRequested();
}

class PaiementCreateRequested extends PaiementEvent {
  final Map<String, dynamic> data;

  const PaiementCreateRequested(this.data);

  @override
  List<Object?> get props => [data];
}

class PaiementUpdateRequested extends PaiementEvent {
  final int id;
  final Map<String, dynamic> data;

  const PaiementUpdateRequested({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

class PaiementDeleteRequested extends PaiementEvent {
  final int id;

  const PaiementDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class PaiementArrieresRequested extends PaiementEvent {
  const PaiementArrieresRequested();
}
