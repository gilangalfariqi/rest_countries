import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/country.dart';
import '../widgets/info_raw.dart';

class CountryDetailPage extends StatelessWidget {
  final Country country;

  const CountryDetailPage({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                country.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Hero(
                tag: 'flag_${country.name}',
                child: CachedNetworkImage(
                  imageUrl: country.flagUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Official Name
                  _buildSectionTitle('Official Name'),
                  Text(
                    country.officialName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),

                  // Basic Info
                  _buildSectionTitle('Basic Information'),
                  InfoRow(
                    icon: Icons.location_city,
                    label: 'Capital',
                    value: country.capital,
                  ),
                  InfoRow(
                    icon: Icons.public,
                    label: 'Region',
                    value: '${country.region} • ${country.subregion}',
                  ),
                  InfoRow(
                    icon: Icons.people,
                    label: 'Population',
                    value: _formatPopulation(country.population),
                  ),
                  if (country.area != null)
                    InfoRow(
                      icon: Icons.square_foot,
                      label: 'Area',
                      value: '${country.area!.toStringAsFixed(0)} km²',
                    ),
                  const SizedBox(height: 24),

                  // Currencies
                  _buildSectionTitle('Currencies'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: country.currencies.map((currency) {
                      return Chip(
                        avatar: const Icon(Icons.attach_money, size: 18),
                        label: Text(currency),
                        backgroundColor: Colors.green[50],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Languages
                  _buildSectionTitle('Languages'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: country.languages.map((language) {
                      return Chip(
                        avatar: const Icon(Icons.language, size: 18),
                        label: Text(language),
                        backgroundColor: Colors.blue[50],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Timezones
                  _buildSectionTitle('Timezones'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: country.timezones.map((timezone) {
                      return Chip(
                        avatar: const Icon(Icons.access_time, size: 18),
                        label: Text(timezone),
                        backgroundColor: Colors.orange[50],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Additional Info
                  _buildSectionTitle('Additional Information'),
                  InfoRow(
                    icon: Icons.car_rental,
                    label: 'Driving Side',
                    value: country.carSide?.toUpperCase() ?? 'Unknown',
                  ),
                  InfoRow(
                    icon: Icons.flag,
                    label: 'Independent',
                    value: country.independent ? 'Yes' : 'No',
                  ),
                  InfoRow(
                    icon: Icons.info,
                    label: 'Status',
                    value: country.status,
                  ),
                  const SizedBox(height: 32),

                  // Coat of Arms
                  if (country.coatOfArmsUrl.isNotEmpty) ...[
                    _buildSectionTitle('Coat of Arms'),
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: country.coatOfArmsUrl,
                        height: 150,
                        placeholder: (context, url) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  String _formatPopulation(int population) {
    if (population >= 1000000000) {
      return '${(population / 1000000000).toStringAsFixed(1)}B';
    } else if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(1)}M';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    return population.toString();
  }
}