import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/country_repository.dart';

class GetAllCountries implements UseCase<List<Country>, NoParams> {
  final CountryRepository repository;

  GetAllCountries(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call(NoParams params) async {
    return await repository.getAllCountries();
  }
}