import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/country.dart';

abstract class CountryRepository {
  Future<Either<Failure, List<Country>>> getAllCountries();
  Future<Either<Failure, Country>> getCountryByName(String name);
  Future<Either<Failure, List<Country>>> searchCountries(String query);
  Future<Either<Failure, List<Country>>> getCountriesByRegion(String region);
}