part of 'performance_bloc.dart';

abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();

  @override
  List<Object?> get props => [];
}

class PerformanceLoadRequested extends PerformanceEvent {
  final int? athleteId;

  const PerformanceLoadRequested({this.athleteId});

  @override
  List<Object?> get props => [athleteId];
}

class PerformanceRefreshRequested extends PerformanceEvent {
  const PerformanceRefreshRequested();
}

class PerformanceCreateRequested extends PerformanceEvent {
  final Map<String, dynamic> data;

  const PerformanceCreateRequested(this.data);

  @override
  List<Object?> get props => [data];
}

class PerformanceUpdateRequested extends PerformanceEvent {
  final int id;
  final Map<String, dynamic> data;

  const PerformanceUpdateRequested({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

class PerformanceDeleteRequested extends PerformanceEvent {
  final int id;

  const PerformanceDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
