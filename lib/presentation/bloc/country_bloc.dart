import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_countries.dart';
import '../../domain/usecases/get_country_by_name.dart';
import '../../domain/usecases/search_countries.dart';
import 'country_event.dart';
import 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final GetAllCountries getAllCountries;
  final GetCountryByName getCountryByName;
  final SearchCountries searchCountries;

  CountryBloc({
    required this.getAllCountries,
    required this.getCountryByName,
    required this.searchCountries,
  }) : super(CountryInitial()) {
    on<GetAllCountriesEvent>(_onGetAllCountries);
    on<GetCountryByNameEvent>(_onGetCountryByName);
    on<SearchCountriesEvent>(_onSearchCountries);
    on<RefreshCountriesEvent>(_onRefreshCountries);
  }

  Future<void> _onGetAllCountries(
      GetAllCountriesEvent event,
      Emitter<CountryState> emit,
      ) async {
    emit(CountryLoading());

    final result = await getAllCountries(const NoParams());

    result.fold(
          (failure) => emit(CountryError(failure.message, code: failure.code)),
          (countries) => emit(CountriesLoaded(countries)),
    );
  }

  Future<void> _onGetCountryByName(
      GetCountryByNameEvent event,
      Emitter<CountryState> emit,
      ) async {
    emit(CountryLoading());

    final result = await getCountryByName(event.name);

    result.fold(
          (failure) => emit(CountryError(failure.message, code: failure.code)),
          (country) => emit(CountryLoaded(country)),
    );
  }

  Future<void> _onSearchCountries(
      SearchCountriesEvent event,
      Emitter<CountryState> emit,
      ) async {
    if (event.query.isEmpty) {
      emit(CountryEmpty());
      return;
    }

    emit(CountryLoading());

    final result = await searchCountries(event.query);

    result.fold(
          (failure) => emit(CountryError(failure.message, code: failure.code)),
          (countries) {
        if (countries.isEmpty) {
          emit(CountryEmpty());
        } else {
          emit(CountriesLoaded(countries));
        }
      },
    );
  }

  Future<void> _onRefreshCountries(
      RefreshCountriesEvent event,
      Emitter<CountryState> emit,
      ) async {
    emit(CountryLoading());

    final result = await getAllCountries(const NoParams());

    result.fold(
          (failure) => emit(CountryError(failure.message, code: failure.code)),
          (countries) => emit(CountriesLoaded(countries)),
    );
  }
}