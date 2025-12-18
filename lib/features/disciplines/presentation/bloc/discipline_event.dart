part of 'discipline_bloc.dart';

abstract class DisciplineEvent extends Equatable {
  const DisciplineEvent();

  @override
  List<Object?> get props => [];
}

class DisciplineLoadRequested extends DisciplineEvent {
  const DisciplineLoadRequested();
}

class DisciplineRefreshRequested extends DisciplineEvent {
  const DisciplineRefreshRequested();
}
