part of 'athlete_bloc.dart';

abstract class AthleteEvent extends Equatable {
  const AthleteEvent();

  @override
  List<Object?> get props => [];
}

class AthleteLoadRequested extends AthleteEvent {
  final bool actifOnly;
  
  const AthleteLoadRequested({this.actifOnly = false});

  @override
  List<Object?> get props => [actifOnly];
}

class AthleteRefreshRequested extends AthleteEvent {
  const AthleteRefreshRequested();
}

class AthleteSearchChanged extends AthleteEvent {
  final String query;

  const AthleteSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class AthleteCreateRequested extends AthleteEvent {
  final Map<String, dynamic> data;

  const AthleteCreateRequested(this.data);

  @override
  List<Object?> get props => [data];
}

class AthleteUpdateRequested extends AthleteEvent {
  final int id;
  final Map<String, dynamic> data;

  const AthleteUpdateRequested({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

class AthleteDeleteRequested extends AthleteEvent {
  final int id;

  const AthleteDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
