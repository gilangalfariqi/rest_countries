class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://restcountries.com/v3.1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String allCountries = '/all';
  static const String countryByName = '/name';
  static const String countryByCode = '/alpha';
  static const String countriesByRegion = '/region';
  static const String countriesByCurrency = '/currency';
  static const String countriesByLanguage = '/lang';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // PERBAIKAN: Maksimal 10 fields sesuai dokumentasi API
  // Pilih fields yang paling penting: name, capital, region, population, flags, coatOfArms, cca2, area, subregion, status
  static const String fields = 'name,capital,region,population,flags,coatOfArms,cca2,area,subregion,status';

  // Fields untuk detail (jika perlu lebih banyak, buat request terpisah tanpa fields)
  static const String detailFields = 'name,capital,region,subregion,population,currencies,languages,flags,coatOfArms,cca2';
}