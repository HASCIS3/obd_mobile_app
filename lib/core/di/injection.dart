import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/sync_service.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/athletes/data/datasources/athlete_remote_datasource.dart';
import '../../features/athletes/data/repositories/athlete_repository_impl.dart';
import '../../features/athletes/domain/repositories/athlete_repository.dart';
import '../../features/athletes/presentation/bloc/athlete_bloc.dart';
import '../../features/disciplines/data/datasources/discipline_remote_datasource.dart';
import '../../features/disciplines/data/repositories/discipline_repository_impl.dart';
import '../../features/disciplines/domain/repositories/discipline_repository.dart';
import '../../features/disciplines/presentation/bloc/discipline_bloc.dart';
import '../../features/paiements/data/datasources/paiement_remote_datasource.dart';
import '../../features/paiements/data/repositories/paiement_repository_impl.dart';
import '../../features/paiements/domain/repositories/paiement_repository.dart';
import '../../features/paiements/presentation/bloc/paiement_bloc.dart';
import '../../features/presences/data/datasources/presence_remote_datasource.dart';
import '../../features/presences/data/repositories/presence_repository_impl.dart';
import '../../features/presences/domain/repositories/presence_repository.dart';
import '../../features/presences/presentation/bloc/presence_bloc.dart';
import '../../features/performances/data/datasources/performance_remote_datasource.dart';
import '../../features/performances/data/repositories/performance_repository_impl.dart';
import '../../features/performances/domain/repositories/performance_repository.dart';
import '../../features/performances/presentation/bloc/performance_bloc.dart';

/// Instance globale de GetIt pour l'injection de dépendances
final GetIt sl = GetIt.instance;

/// Initialise toutes les dépendances de l'application
Future<void> initializeDependencies() async {
  // ===== Core =====
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  
  sl.registerLazySingleton<DioClient>(
    () => DioClient(networkInfo: sl<NetworkInfo>()),
  );

  // Sync Service
  sl.registerLazySingleton<SyncService>(
    () => SyncService(dioClient: sl<DioClient>()),
  );

  // ===== Auth Feature =====
  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: sl<AuthRepository>(),
      dioClient: sl<DioClient>(),
    ),
  );

  // ===== Dashboard Feature =====
  // Data Sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Bloc
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(repository: sl<DashboardRepository>()),
  );

  // ===== Athletes Feature =====
  sl.registerLazySingleton<AthleteRemoteDataSource>(
    () => AthleteRemoteDataSourceImpl(client: sl<DioClient>()),
  );
  sl.registerLazySingleton<AthleteRepository>(
    () => AthleteRepositoryImpl(
      remoteDataSource: sl<AthleteRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerFactory<AthleteBloc>(
    () => AthleteBloc(repository: sl<AthleteRepository>()),
  );

  // ===== Disciplines Feature =====
  sl.registerLazySingleton<DisciplineRemoteDataSource>(
    () => DisciplineRemoteDataSourceImpl(client: sl<DioClient>()),
  );
  sl.registerLazySingleton<DisciplineRepository>(
    () => DisciplineRepositoryImpl(
      remoteDataSource: sl<DisciplineRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerFactory<DisciplineBloc>(
    () => DisciplineBloc(repository: sl<DisciplineRepository>()),
  );

  // ===== Paiements Feature =====
  sl.registerLazySingleton<PaiementRemoteDataSource>(
    () => PaiementRemoteDataSourceImpl(client: sl<DioClient>()),
  );
  sl.registerLazySingleton<PaiementRepository>(
    () => PaiementRepositoryImpl(
      remoteDataSource: sl<PaiementRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerFactory<PaiementBloc>(
    () => PaiementBloc(repository: sl<PaiementRepository>()),
  );

  // ===== Presences Feature =====
  sl.registerLazySingleton<PresenceRemoteDataSource>(
    () => PresenceRemoteDataSourceImpl(client: sl<DioClient>()),
  );
  sl.registerLazySingleton<PresenceRepository>(
    () => PresenceRepositoryImpl(
      remoteDataSource: sl<PresenceRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerFactory<PresenceBloc>(
    () => PresenceBloc(repository: sl<PresenceRepository>()),
  );

  // ===== Performances Feature =====
  sl.registerLazySingleton<PerformanceRemoteDataSource>(
    () => PerformanceRemoteDataSourceImpl(client: sl<DioClient>()),
  );
  sl.registerLazySingleton<PerformanceRepository>(
    () => PerformanceRepositoryImpl(
      remoteDataSource: sl<PerformanceRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerFactory<PerformanceBloc>(
    () => PerformanceBloc(repository: sl<PerformanceRepository>()),
  );
}

/// Réinitialise toutes les dépendances (utile pour les tests)
Future<void> resetDependencies() async {
  await sl.reset();
}
