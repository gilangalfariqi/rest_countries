import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/country_bloc.dart';
import '../bloc/country_event.dart';
import '../bloc/country_state.dart';
import '../widgets/country_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'country_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      context.read<CountryBloc>().add(SearchCountriesEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search countries...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<CountryBloc>().add(GetAllCountriesEvent());
              },
            )
                : null,
          ),
          style: const TextStyle(fontSize: 18),
          onChanged: _onSearchChanged,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CountryBloc, CountryState>(
        builder: (context, state) {
          if (state is CountryLoading) {
            return const LoadingWidget();
          } else if (state is CountriesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.countries.length,
              itemBuilder: (context, index) {
                final country = state.countries[index];
                return CountryCard(
                  country: country,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CountryDetailPage(country: country),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is CountryError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                if (_searchController.text.isNotEmpty) {
                  context.read<CountryBloc>().add(
                    SearchCountriesEvent(_searchController.text),
                  );
                }
              },
            );
          } else if (state is CountryEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No countries found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CountryInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start typing to search countries',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}