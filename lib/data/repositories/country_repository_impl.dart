import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/country_local_datasource.dart';
import '../datasources/country_remote_datasource.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDataSource remoteDataSource;
  final CountryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CountryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Country>>> getAllCountries() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCountries = await remoteDataSource.getAllCountries();
        await localDataSource.cacheCountries(remoteCountries);
        return Right(remoteCountries);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.code));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message, code: e.code));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      try {
        final localCountries = await localDataSource.getCachedCountries();
        return Right(localCountries);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Country>> getCountryByName(String name) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCountry = await remoteDataSource.getCountryByName(name);
        return Right(remoteCountry);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.code));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message, code: e.code));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Country>>> searchCountries(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCountries = await remoteDataSource.searchCountries(query);
        return Right(remoteCountries);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.code));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message, code: e.code));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Country>>> getCountriesByRegion(String region) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCountries = await remoteDataSource.getCountriesByRegion(region);
        return Right(remoteCountries);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message, code: e.code));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message, code: e.code));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}