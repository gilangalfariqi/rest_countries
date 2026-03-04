import '../../core/errors/exceptions.dart';
import '../models/country_model.dart';

abstract class CountryLocalDataSource {
  Future<List<CountryModel>> getCachedCountries();
  Future<void> cacheCountries(List<CountryModel> countries);
}

class CountryLocalDataSourceImpl implements CountryLocalDataSource {
  // In-memory cache for simplicity. In production, use Hive or SQLite
  List<CountryModel>? _cachedCountries;

  @override
  Future<List<CountryModel>> getCachedCountries() async {
    if (_cachedCountries != null) {
      return _cachedCountries!;
    }
    throw CacheException('No cached data available');
  }

  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
    _cachedCountries = countries;
  }
}