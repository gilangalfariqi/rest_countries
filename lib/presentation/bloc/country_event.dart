import 'package:equatable/equatable.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object?> get props => [];
}

class GetAllCountriesEvent extends CountryEvent {}

class GetCountryByNameEvent extends CountryEvent {
  final String name;

  const GetCountryByNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class SearchCountriesEvent extends CountryEvent {
  final String query;

  const SearchCountriesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshCountriesEvent extends CountryEvent {}