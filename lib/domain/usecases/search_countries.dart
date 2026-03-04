import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/country_repository.dart';

class SearchCountries implements UseCase<List<Country>, String> {
  final CountryRepository repository;

  SearchCountries(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call(String query) async {
    return await repository.searchCountries(query);
  }
}