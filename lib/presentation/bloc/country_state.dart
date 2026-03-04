import 'package:equatable/equatable.dart';
import '../../domain/entities/country.dart';

abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object?> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountriesLoaded extends CountryState {
  final List<Country> countries;

  const CountriesLoaded(this.countries);

  @override
  List<Object?> get props => [countries];
}

class CountryLoaded extends CountryState {
  final Country country;

  const CountryLoaded(this.country);

  @override
  List<Object?> get props => [country];
}

class CountryError extends CountryState {
  final String message;
  final String? code;

  const CountryError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class CountryEmpty extends CountryState {}