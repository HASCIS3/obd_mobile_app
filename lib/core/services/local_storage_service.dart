import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

/// Service de stockage local avec Hive
class LocalStorageService {
  static const String _athletesBox = 'athletes';
  static const String _disciplinesBox = 'disciplines';
  static const String _presencesBox = 'presences';
  static const String _paiementsBox = 'paiements';
  static const String _pendingSyncBox = 'pending_sync';
  static const String _dashboardBox = 'dashboard';

  /// Initialiser Hive
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  /// Ouvrir toutes les boxes
  static Future<void> openBoxes() async {
    await Hive.openBox(_athletesBox);
    await Hive.openBox(_disciplinesBox);
    await Hive.openBox(_presencesBox);
    await Hive.openBox(_paiementsBox);
    await Hive.openBox(_pendingSyncBox);
    await Hive.openBox(_dashboardBox);
  }

  // ==================== ATHLETES ====================
  
  static Future<void> saveAthletes(List<Map<String, dynamic>> athletes) async {
    final box = Hive.box(_athletesBox);
    await box.clear();
    for (var athlete in athletes) {
      await box.put(athlete['id'].toString(), jsonEncode(athlete));
    }
  }

  static List<Map<String, dynamic>> getAthletes() {
    final box = Hive.box(_athletesBox);
    return box.values.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> saveAthlete(Map<String, dynamic> athlete) async {
    final box = Hive.box(_athletesBox);
    await box.put(athlete['id'].toString(), jsonEncode(athlete));
  }

  // ==================== DISCIPLINES ====================
  
  static Future<void> saveDisciplines(List<Map<String, dynamic>> disciplines) async {
    final box = Hive.box(_disciplinesBox);
    await box.clear();
    for (var discipline in disciplines) {
      await box.put(discipline['id'].toString(), jsonEncode(discipline));
    }
  }

  static List<Map<String, dynamic>> getDisciplines() {
    final box = Hive.box(_disciplinesBox);
    return box.values.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // ==================== PRESENCES ====================
  
  static Future<void> savePresences(List<Map<String, dynamic>> presences) async {
    final box = Hive.box(_presencesBox);
    await box.clear();
    for (var presence in presences) {
      await box.put(presence['id'].toString(), jsonEncode(presence));
    }
  }

  static List<Map<String, dynamic>> getPresences() {
    final box = Hive.box(_presencesBox);
    return box.values.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // ==================== PAIEMENTS ====================
  
  static Future<void> savePaiements(List<Map<String, dynamic>> paiements) async {
    final box = Hive.box(_paiementsBox);
    await box.clear();
    for (var paiement in paiements) {
      await box.put(paiement['id'].toString(), jsonEncode(paiement));
    }
  }

  static List<Map<String, dynamic>> getPaiements() {
    final box = Hive.box(_paiementsBox);
    return box.values.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // ==================== DASHBOARD ====================
  
  static Future<void> saveDashboard(Map<String, dynamic> dashboard) async {
    final box = Hive.box(_dashboardBox);
    await box.put('data', jsonEncode(dashboard));
  }

  static Map<String, dynamic>? getDashboard() {
    final box = Hive.box(_dashboardBox);
    final data = box.get('data');
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  // ==================== PENDING SYNC ====================
  
  /// Ajouter une opération en attente de synchronisation
  static Future<void> addPendingSync(Map<String, dynamic> operation) async {
    final box = Hive.box(_pendingSyncBox);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    operation['pending_id'] = id;
    operation['created_at'] = DateTime.now().toIso8601String();
    await box.put(id, jsonEncode(operation));
  }

  /// Récupérer toutes les opérations en attente
  static List<Map<String, dynamic>> getPendingSyncOperations() {
    final box = Hive.box(_pendingSyncBox);
    return box.values.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  /// Supprimer une opération synchronisée
  static Future<void> removePendingSync(String pendingId) async {
    final box = Hive.box(_pendingSyncBox);
    await box.delete(pendingId);
  }

  /// Vérifier s'il y a des opérations en attente
  static bool hasPendingSync() {
    final box = Hive.box(_pendingSyncBox);
    return box.isNotEmpty;
  }

  /// Nombre d'opérations en attente
  static int pendingSyncCount() {
    final box = Hive.box(_pendingSyncBox);
    return box.length;
  }

  /// Effacer toutes les données locales
  static Future<void> clearAll() async {
    await Hive.box(_athletesBox).clear();
    await Hive.box(_disciplinesBox).clear();
    await Hive.box(_presencesBox).clear();
    await Hive.box(_paiementsBox).clear();
    await Hive.box(_pendingSyncBox).clear();
    await Hive.box(_dashboardBox).clear();
  }
}
