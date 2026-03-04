import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final List<String> currencies;
  final List<String> languages;
  final String flagUrl;
  final String coatOfArmsUrl;
  final double? area;
  final String? googleMapsUrl;
  final List<String> timezones;
  final String? carSide;
  final bool independent;
  final String status;
  final String? flagEmoji;

  const Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.currencies,
    required this.languages,
    required this.flagUrl,
    required this.coatOfArmsUrl,
    this.area,
    this.googleMapsUrl,
    required this.timezones,
    this.carSide,
    required this.independent,
    required this.status,
    this.flagEmoji,
  });

  @override
  List<Object?> get props => [
    name,
    officialName,
    capital,
    region,
    subregion,
    population,
    currencies,
    languages,
    flagUrl,
    coatOfArmsUrl,
  ];
}