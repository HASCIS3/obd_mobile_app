// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      athletesActifs: (json['athletes_actifs'] as num).toInt(),
      athletesTotal: (json['athletes_total'] as num).toInt(),
      disciplines: (json['disciplines'] as num).toInt(),
      presencesJour: (json['presences_jour'] as num).toInt(),
      paiements: PaiementStats.fromJson(
        json['paiements'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
  DashboardStatsModel instance,
) => <String, dynamic>{
  'athletes_actifs': instance.athletesActifs,
  'athletes_total': instance.athletesTotal,
  'disciplines': instance.disciplines,
  'presences_jour': instance.presencesJour,
  'paiements': instance.paiements,
};

PaiementStats _$PaiementStatsFromJson(Map<String, dynamic> json) =>
    PaiementStats(
      total: (json['total'] as num).toInt(),
      paye: (json['paye'] as num).toInt(),
      arrieres: (json['arrieres'] as num).toInt(),
    );

Map<String, dynamic> _$PaiementStatsToJson(PaiementStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'paye': instance.paye,
      'arrieres': instance.arrieres,
    };

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      athlete: json['athlete'] as String?,
      discipline: json['discipline'] as String?,
      date: DateTime.parse(json['date'] as String),
      present: json['present'] as bool?,
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'athlete': instance.athlete,
      'discipline': instance.discipline,
      'date': instance.date.toIso8601String(),
      'present': instance.present,
    };

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      stats: DashboardStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>,
      ),
      activitesRecentes: (json['activites_recentes'] as List<dynamic>)
          .map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: DashboardUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardResponseToJson(DashboardResponse instance) =>
    <String, dynamic>{
      'stats': instance.stats,
      'activites_recentes': instance.activitesRecentes,
      'user': instance.user,
    };

DashboardUser _$DashboardUserFromJson(Map<String, dynamic> json) =>
    DashboardUser(name: json['name'] as String, role: json['role'] as String?);

Map<String, dynamic> _$DashboardUserToJson(DashboardUser instance) =>
    <String, dynamic>{'name': instance.name, 'role': instance.role};
