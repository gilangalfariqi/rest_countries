import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/country_model.dart';

abstract class CountryRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
  Future<CountryModel> getCountryByName(String name);
  Future<List<CountryModel>> searchCountries(String query);
  Future<List<CountryModel>> getCountriesByRegion(String region);
}

class CountryRemoteDataSourceImpl implements CountryRemoteDataSource {
  final ApiClient apiClient;

  CountryRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<CountryModel>> getAllCountries() async {
    try {
      final response = await apiClient.get(
        ApiConstants.allCountries,
        queryParameters: {
          'fields': ApiConstants.listFields,
        },
      );

      if (response is List) {
        return response.map((json) => CountryModel.fromJson(json)).toList();
      }
      throw const ServerException('Invalid response format');
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<CountryModel> getCountryByName(String name) async {
    try {
      final encodedName = Uri.encodeComponent(name);
      // PERBAIKAN: Hapus fields filter untuk mendapatkan SEMUA data lengkap
      final response = await apiClient.get(
        '${ApiConstants.countryByName}/$encodedName',
        queryParameters: {
          'fullText': 'true',
          // Tidak ada 'fields' parameter = get all fields
        },
      );

      if (response is List && response.isNotEmpty) {
        return CountryModel.fromJson(response[0]);
      }
      throw const ServerException('Country not found');
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<List<CountryModel>> searchCountries(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final response = await apiClient.get(
        '${ApiConstants.countryByName}/$encodedQuery',
        queryParameters: {
          'fields': ApiConstants.listFields,
        },
      );

      if (response is List) {
        return response.map((json) => CountryModel.fromJson(json)).toList();
      }
      throw const ServerException('Invalid response format');
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByRegion(String region) async {
    try {
      final encodedRegion = Uri.encodeComponent(region);
      final response = await apiClient.get(
        '${ApiConstants.countriesByRegion}/$encodedRegion',
        queryParameters: {
          'fields': ApiConstants.listFields,
        },
      );

      if (response is List) {
        return response.map((json) => CountryModel.fromJson(json)).toList();
      }
      throw const ServerException('Invalid response format');
    } on AppException {
      rethrow;
    } catch (e, stackTrace) {
      throw ServerException(e.toString(), stackTrace: stackTrace);
    }
  }
}