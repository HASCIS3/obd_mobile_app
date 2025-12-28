import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../di/injection.dart';
import '../network/dio_client.dart';
import 'local_storage_service.dart';

/// Service de synchronisation des données
class SyncService {
  final DioClient _dioClient;
  bool _isSyncing = false;

  SyncService({required DioClient dioClient}) : _dioClient = dioClient;

  /// Vérifier si on est connecté à Internet
  Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.isNotEmpty && 
           !connectivityResult.contains(ConnectivityResult.none);
  }

  /// Synchroniser toutes les opérations en attente
  Future<SyncResult> syncPendingOperations() async {
    if (_isSyncing) {
      return SyncResult(success: false, message: 'Synchronisation déjà en cours');
    }

    if (!await isOnline()) {
      return SyncResult(success: false, message: 'Pas de connexion Internet');
    }

    _isSyncing = true;
    int synced = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final pendingOps = LocalStorageService.getPendingSyncOperations();
      
      for (final op in pendingOps) {
        try {
          final success = await _executeOperation(op);
          if (success) {
            await LocalStorageService.removePendingSync(op['pending_id']);
            synced++;
          } else {
            failed++;
          }
        } catch (e) {
          failed++;
          errors.add('Erreur: $e');
          debugPrint('Sync error: $e');
        }
      }

      return SyncResult(
        success: failed == 0,
        message: 'Synchronisé: $synced, Échecs: $failed',
        syncedCount: synced,
        failedCount: failed,
        errors: errors,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Exécuter une opération en attente
  Future<bool> _executeOperation(Map<String, dynamic> operation) async {
    final type = operation['type'] as String;
    final endpoint = operation['endpoint'] as String;
    final data = operation['data'] as Map<String, dynamic>?;

    try {
      switch (type) {
        case 'POST':
          await _dioClient.post(endpoint, data: data);
          return true;
        case 'PUT':
          await _dioClient.put(endpoint, data: data);
          return true;
        case 'DELETE':
          await _dioClient.delete(endpoint);
          return true;
        default:
          debugPrint('Unknown operation type: $type');
          return false;
      }
    } catch (e) {
      debugPrint('Operation failed: $e');
      return false;
    }
  }

  /// Écouter les changements de connectivité et synchroniser automatiquement
  void startAutoSync() {
    Connectivity().onConnectivityChanged.listen((result) async {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        // On est de nouveau en ligne, synchroniser
        if (LocalStorageService.hasPendingSync()) {
          debugPrint('Connexion rétablie, synchronisation en cours...');
          await syncPendingOperations();
        }
      }
    });
  }
}

/// Résultat de la synchronisation
class SyncResult {
  final bool success;
  final String message;
  final int syncedCount;
  final int failedCount;
  final List<String> errors;

  SyncResult({
    required this.success,
    required this.message,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.errors = const [],
  });
}
