import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_model.g.dart';

@JsonSerializable()
class DashboardStatsModel extends Equatable {
  @JsonKey(name: 'athletes_actifs')
  final int athletesActifs;
  
  @JsonKey(name: 'athletes_total')
  final int athletesTotal;
  
  final int disciplines;
  
  @JsonKey(name: 'presences_jour')
  final int presencesJour;
  
  final PaiementStats paiements;

  const DashboardStatsModel({
    required this.athletesActifs,
    required this.athletesTotal,
    required this.disciplines,
    required this.presencesJour,
    required this.paiements,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);

  @override
  List<Object?> get props => [
        athletesActifs,
        athletesTotal,
        disciplines,
        presencesJour,
        paiements,
      ];
}

@JsonSerializable()
class PaiementStats extends Equatable {
  final int total;
  final int paye;
  final int arrieres;

  const PaiementStats({
    required this.total,
    required this.paye,
    required this.arrieres,
  });

  factory PaiementStats.fromJson(Map<String, dynamic> json) =>
      _$PaiementStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PaiementStatsToJson(this);

  double get pourcentagePaye => total > 0 ? (paye / total) * 100 : 0;

  @override
  List<Object?> get props => [total, paye, arrieres];
}

@JsonSerializable()
class ActivityModel extends Equatable {
  final int id;
  final String type;
  final String? athlete;
  final String? discipline;
  final DateTime date;
  final bool? present;

  const ActivityModel({
    required this.id,
    required this.type,
    this.athlete,
    this.discipline,
    required this.date,
    this.present,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  @override
  List<Object?> get props => [id, type, athlete, discipline, date, present];
}

@JsonSerializable()
class DashboardResponse extends Equatable {
  final DashboardStatsModel stats;
  
  @JsonKey(name: 'activites_recentes')
  final List<ActivityModel> activitesRecentes;
  
  final DashboardUser user;

  const DashboardResponse({
    required this.stats,
    required this.activitesRecentes,
    required this.user,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardResponseToJson(this);

  @override
  List<Object?> get props => [stats, activitesRecentes, user];
}

@JsonSerializable()
class DashboardUser extends Equatable {
  final String name;
  final String? role;

  const DashboardUser({
    required this.name,
    this.role,
  });

  factory DashboardUser.fromJson(Map<String, dynamic> json) =>
      _$DashboardUserFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardUserToJson(this);

  @override
  List<Object?> get props => [name, role];
}
