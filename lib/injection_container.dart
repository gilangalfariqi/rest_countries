import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'data/datasources/country_local_datasource.dart';
import 'data/datasources/country_remote_datasource.dart';
import 'data/repositories/country_repository_impl.dart';
import 'domain/repositories/country_repository.dart';
import 'domain/usecases/get_all_countries.dart';
import 'domain/usecases/get_country_by_name.dart';
import 'domain/usecases/search_countries.dart';
import 'presentation/bloc/country_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Logger());

  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClientImpl(sl(), sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Data sources
  sl.registerLazySingleton<CountryRemoteDataSource>(
        () => CountryRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CountryLocalDataSource>(
        () => CountryLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<CountryRepository>(
        () => CountryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllCountries(sl()));
  sl.registerLazySingleton(() => GetCountryByName(sl()));
  sl.registerLazySingleton(() => SearchCountries(sl()));

  // Bloc
  sl.registerFactory(
        () => CountryBloc(
      getAllCountries: sl(),
      getCountryByName: sl(),
      searchCountries: sl(),
    ),
  );
}