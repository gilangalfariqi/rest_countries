import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/country_bloc.dart';
import '../bloc/country_event.dart';
import '../bloc/country_state.dart';
import '../widgets/country_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'country_detail_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CountryBloc>().add(GetAllCountriesEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Countries of the World',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CountryBloc>().add(RefreshCountriesEvent());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CountryBloc>().add(RefreshCountriesEvent());
        },
        child: BlocBuilder<CountryBloc, CountryState>(
          builder: (context, state) {
            if (state is CountryLoading) {
              return const LoadingWidget();
            } else if (state is CountriesLoaded) {
              return ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
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
                  context.read<CountryBloc>().add(GetAllCountriesEvent());
                },
              );
            } else if (state is CountryInitial) {
              return const Center(child: Text('Welcome to Countries App'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}