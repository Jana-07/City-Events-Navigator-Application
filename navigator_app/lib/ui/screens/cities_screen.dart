import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Define the SaudiCity model (similar to the original City model)
class SaudiCity {
  final String name;
  final String imageUrl; // Placeholder for image URL
  // Add other relevant fields if needed, e.g., description, coordinates

  const SaudiCity({
    required this.name,
    required this.imageUrl,
  });
}

// List of Saudi cities (from pasted_content.txt)
// TODO: Replace placeholder image URLs with actual ones
final List<SaudiCity> saudiCities = [
  SaudiCity(
      name: 'Riyadh',
      imageUrl:
          'https://res.cloudinary.com/dcq4awvap/image/upload/v1745941619/Riyadh_yiwciy.jpg'),
  SaudiCity(
      name: 'Qassim',
      imageUrl:
          'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942323/Qassim_lrxebj.jpg'),
  SaudiCity(
      name: 'Jeddah',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942321/Jeddah_iwm21c.jpg'),
  SaudiCity(
      name: 'Mecca',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942321/Mecca_ddfjcu.jpg'),
  SaudiCity(
      name: 'Medina',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942323/Medina_g2gq4s.jpg'),
  SaudiCity(
      name: 'Dammam',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942322/Dammam_nym0ux.jpg'),
  SaudiCity(
      name: 'Khobar',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942321/Khobar_mf3puz.jpg'),
  SaudiCity(
      name: 'Taif',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942323/Taif_bmf3y4.jpg'),
  SaudiCity(
      name: 'Tabuk',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942320/Tabuk_alejav.jpg'),
  SaudiCity(
      name: 'Abha',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942323/Abha_kgjcgm.jpg'),
  SaudiCity(
      name: 'Yanbu',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942321/Yanbu_zxrkmr.jpg'),
  SaudiCity(
      name: 'Jizan',
      imageUrl: 'https://res.cloudinary.com/dcq4awvap/image/upload/v1745942320/Jizan_nkwwte.jpg'),
];

class CitiesScreen extends ConsumerWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

class SaudiCityCard extends StatelessWidget {
  final SaudiCity city;

  const SaudiCityCard({
    super.key,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to a filtered event list screen
        // Assuming a route like '/events' that accepts a 'city' query parameter
        context.push("/events?city=${Uri.encodeComponent(city.name)}");
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
