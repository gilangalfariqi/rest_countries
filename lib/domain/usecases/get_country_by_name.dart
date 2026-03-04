import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/country_repository.dart';

class GetCountryByName implements UseCase<Country, String> {
  final CountryRepository repository;

  GetCountryByName(this.repository);

  @override
  Future<Either<Failure, Country>> call(String name) async {
    return await repository.getCountryByName(name);
  }
}