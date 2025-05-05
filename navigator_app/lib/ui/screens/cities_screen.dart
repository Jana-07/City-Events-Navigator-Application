import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:navigator_app/data/models/saudi_city.dart';
import 'package:navigator_app/providers/filter_provider.dart';
import 'package:navigator_app/router/routes.dart';

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Events By Cities'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust columns as needed
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Adjust aspect ratio as needed
          ),
          itemCount: saudiCities.length,
          itemBuilder: (context, index) {
            final city = saudiCities[index];
            return SaudiCityCard(city: city);
          },
        ),
      ),
    );
  }
}

class SaudiCityCard extends ConsumerWidget {
  final SaudiCity city;

  const SaudiCityCard({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(eventFiltersProvider('all').notifier).updateCity(city.name);
        context.pushNamed(Routes.eventListName);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Use CachedNetworkImage for efficient loading and caching
            CachedNetworkImage(
              imageUrl: city.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.error_outline,
                      size: 40, color: Colors.black54),
                ),
              ),
            ),

            // Gradient overlay for text visibility
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),

            // City name
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                city.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
