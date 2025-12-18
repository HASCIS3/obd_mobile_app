part of 'presence_bloc.dart';

abstract class PresenceEvent extends Equatable {
  const PresenceEvent();

  @override
  List<Object?> get props => [];
}

class PresenceLoadRequested extends PresenceEvent {
  final int? athleteId;
  final String? date;

  const PresenceLoadRequested({this.athleteId, this.date});

  @override
  List<Object?> get props => [athleteId, date];
}

class PresenceRefreshRequested extends PresenceEvent {
  const PresenceRefreshRequested();
}

class PresenceCreateRequested extends PresenceEvent {
  final Map<String, dynamic> data;

  const PresenceCreateRequested(this.data);

  @override
  List<Object?> get props => [data];
}

class PresenceUpdateRequested extends PresenceEvent {
  final int id;
  final Map<String, dynamic> data;

  const PresenceUpdateRequested({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

class PresenceDeleteRequested extends PresenceEvent {
  final int id;

  const PresenceDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class PresencePointageMasseRequested extends PresenceEvent {
  final List<Map<String, dynamic>> presences;

  const PresencePointageMasseRequested(this.presences);

  @override
  List<Object?> get props => [presences];
}
