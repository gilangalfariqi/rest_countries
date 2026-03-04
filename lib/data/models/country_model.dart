import '../../domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.name,
    required super.officialName,
    required super.capital,
    required super.region,
    required super.subregion,
    required super.population,
    required super.currencies,
    required super.languages,
    required super.flagUrl,
    required super.coatOfArmsUrl,
    super.area,
    super.googleMapsUrl,
    required super.timezones,
    super.carSide,
    required super.independent,
    required super.status,
    super.flagEmoji,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    // Helper functions dengan parameter json yang eksplisit
    String getName(Map<String, dynamic> json) {
      if (json['name'] is Map) {
        return json['name']['common']?.toString() ?? 'Unknown';
      }
      return 'Unknown';
    }

    String getOfficialName(Map<String, dynamic> json) {
      if (json['name'] is Map) {
        return json['name']['official']?.toString() ?? 'Unknown';
      }
      return 'Unknown';
    }

    String getCapital(Map<String, dynamic> json) {
      if (json['capital'] is List && (json['capital'] as List).isNotEmpty) {
        return json['capital'][0].toString();
      }
      // Fallback jika capital tidak ada di fields
      return json['capital']?.toString() ?? 'No Capital';
    }

    List<String> getCurrencies(Map<String, dynamic> json) {
      final currencies = <String>[];
      if (json['currencies'] is Map) {
        (json['currencies'] as Map).forEach((key, value) {
          if (value is Map) {
            final name = value['name']?.toString() ?? key;
            final symbol = value['symbol']?.toString() ?? '';
            currencies.add('$name ($symbol)');
          }
        });
      }
      return currencies.isEmpty ? ['No Currency'] : currencies;
    }

    List<String> getLanguages(Map<String, dynamic> json) {
      final languages = <String>[];
      if (json['languages'] is Map) {
        (json['languages'] as Map).forEach((key, value) {
          languages.add(value.toString());
        });
      }
      return languages.isEmpty ? ['No Language'] : languages;
    }

    String getFlagUrl(Map<String, dynamic> json) {
      return json['flags']?['png']?.toString() ??
          json['flags']?['svg']?.toString() ??
          '';
    }

    String getCoatOfArmsUrl(Map<String, dynamic> json) {
      return json['coatOfArms']?['png']?.toString() ??
          json['coatOfArms']?['svg']?.toString() ??
          '';
    }

    String? getGoogleMapsUrl(Map<String, dynamic> json) {
      return json['maps']?['googleMaps']?.toString();
    }

    List<String> getTimezones(Map<String, dynamic> json) {
      if (json['timezones'] is List) {
        return (json['timezones'] as List).map((e) => e.toString()).toList();
      }
      return ['UTC'];
    }

    String? getCarSide(Map<String, dynamic> json) {
      return json['car']?['side']?.toString();
    }

    String? getFlagEmoji(Map<String, dynamic> json) {
      // Coba ambil dari field 'flag' jika ada
      if (json['flag'] != null) {
        return json['flag'].toString();
      }
      // Generate dari cca2 (ISO 3166-1 alpha-2)
      final String? countryCode = json['cca2']?.toString();
      if (countryCode != null && countryCode.length == 2) {
        return _countryCodeToEmoji(countryCode);
      }
      return null;
    }

    return CountryModel(
      name: getName(json),
      officialName: getOfficialName(json),
      capital: getCapital(json),
      region: json['region']?.toString() ?? 'Unknown',
      subregion: json['subregion']?.toString() ?? 'Unknown',
      population: json['population'] ?? 0,
      currencies: getCurrencies(json),
      languages: getLanguages(json),
      flagUrl: getFlagUrl(json),
      coatOfArmsUrl: getCoatOfArmsUrl(json),
      area: (json['area'] as num?)?.toDouble(),
      googleMapsUrl: getGoogleMapsUrl(json),
      timezones: getTimezones(json),
      carSide: getCarSide(json),
      independent: json['independent'] ?? false,
      status: json['status']?.toString() ?? 'Unknown',
      flagEmoji: getFlagEmoji(json),
    );
  }

  // Helper method untuk convert country code ke emoji flag
  static String _countryCodeToEmoji(String countryCode) {
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {
        'common': name,
        'official': officialName,
      },
      'capital': [capital],
      'region': region,
      'subregion': subregion,
      'population': population,
      'currencies': currencies,
      'languages': languages,
      'flags': {'png': flagUrl},
      'coatOfArms': {'png': coatOfArmsUrl},
      'area': area,
      'maps': {'googleMaps': googleMapsUrl},
      'timezones': timezones,
      'car': {'side': carSide},
      'independent': independent,
      'status': status,
      'flag': flagEmoji,
    };
  }
}