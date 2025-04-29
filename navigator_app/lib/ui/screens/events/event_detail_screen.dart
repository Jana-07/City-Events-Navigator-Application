import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/ui/widgets/common/favorite_button.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventFuture = ref.watch(getEventByIdProvider(eventId));

    return eventFuture.when(
      data: (event) {
        if (event == null) {
          return const Text('Event not found');
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar with Event Image
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        event.imageURL,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey)),
                        // Optional: Add loading builder for image
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                      // Gradient overlay for text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(180)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  // Favorite button
                  FavoriteButton(
                    eventId: event.id,
                    title: event.title,
                    address: event.address,
                    imageURL: event.imageURL,
                    date: event.startDate,
                  ),
                ],
                actionsPadding: const EdgeInsets.all(10),
              ),
              // Main content area
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Title
                      Text(event.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),

                      // --- Date & Time Section ---
                      const Text('Date & Time',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildInfoItem(
                        icon: Icons.calendar_today,
                        title:
                            DateFormat('d MMMM, yyyy').format(event.startDate),
                        subtitle:
                            '${DateFormat('h:mm a').format(event.startDate)} - ${DateFormat('h:mm a').format(event.endDate)}',
                        iconBackgroundColor: Colors.blue.withAlpha(25),
                        iconColor: Colors.blue,
                      ),
                      const SizedBox(height: 24),

                      // --- Location Section ---
                      const Text('Location',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildInfoItem(
                        icon: Icons.location_on,
                        title: event
                            .address, // Assuming address is detailed enough
                        subtitle: 'View on map', // Changed subtitle for clarity
                        iconBackgroundColor: Colors.orange.withAlpha(25),
                        iconColor: Colors.orange,
                      ),
                      const SizedBox(height: 24),

                      // --- Organizer Section ---
                      // const Text('Organizer',
                      //     style: TextStyle(
                      //         fontSize: 18, fontWeight: FontWeight.bold)),
                      // const SizedBox(height: 8),
                      // _buildOrganizerItem(
                      //   role: 'Organizer',
                      //   name: event.organizerName,
                      //   imageUrl: event.organizerProfilePictureUrl,
                      // ),
                      // const SizedBox(height: 24),

                      // --- About Event Section ---
                      const Text('About Event',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // Rating Bar
                      // Row(
                      //   children: [
                      //     RatingBarIndicator(
                      //       rating: event.averageRating,
                      //       itemCount: 5,
                      //       itemSize: 20,
                      //       direction: Axis.horizontal,
                      //       itemBuilder: (context, _) => const Icon(
                      //           Icons.star_rate_rounded,
                      //           color: Colors.amber),
                      //     ),
                      //     const SizedBox(width: 8),
                      //     Text(
                      //       '${event.averageRating.toStringAsFixed(1)} (${event.reviewsCount} reviews)', // Added review count
                      //       style: TextStyle(
                      //           color: Colors.grey[600],
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 16),
                      // Description
                      Text(event.description,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              height: 1.5)),
                      const SizedBox(height: 24),

                      // --- Tags Section (New) ---
                      if (event.tags.isNotEmpty) ...[
                        const Text('Tags',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0, // gap between adjacent chips
                          runSpacing: 4.0, // gap between lines
                          children: event.tags
                              .map((tag) => Chip(
                                    label: Text(tag),
                                    backgroundColor: Theme.of(context)
                                            .chipTheme
                                            .backgroundColor ??
                                        Colors.grey[200],
                                    labelStyle:
                                        Theme.of(context).chipTheme.labelStyle,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // --- Event Details Section ---
                      const Text('Event Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Price
                          _buildInfoItemRounded(
                            icon: Icons.attach_money_rounded,
                            iconBackgroundColor: Colors.green.withAlpha(25),
                            iconColor: Colors.green,
                            title: event.price == 0
                                ? 'Free'
                                : '\$${event.price.toStringAsFixed(2)}', // Added currency symbol
                          ),
                          const SizedBox(width: 30),
                          // Category
                          _buildInfoItemRounded(
                            icon: Icons.abc,
                            iconBackgroundColor: const Color.fromARGB(255, 171, 200, 224),
                            //iconBackgroundColor: category.color.withAlpha(200),
                            iconColor: Colors.white,
                            title: event.category,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // --- Ticket Button (New) ---
                      // if (event.ticketURL.isNotEmpty) ...[
                      //   SizedBox(
                      //     width: double.infinity,
                      //     child: ElevatedButton.icon(
                      //       icon:
                      //           const Icon(Icons.confirmation_number_outlined),
                      //       label: const Text('GET TICKETS / REGISTER'),
                      //       onPressed: () async {
                      //         final Uri url = Uri.parse(event.ticketURL);
                      //         if (!await launchUrl(url,
                      //             mode: LaunchMode.externalApplication)) {
                      //           // Handle error if URL can't be launched
                      //           if (context.mounted) {
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //               SnackBar(
                      //                   content: Text(
                      //                       'Could not launch ${event.ticketURL}')),
                      //             );
                      //           }
                      //         }
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Theme.of(context)
                      //             .colorScheme
                      //             .primary, // Use primary color
                      //         foregroundColor:
                      //             Theme.of(context).colorScheme.onPrimary,
                      //         padding: const EdgeInsets.symmetric(vertical: 16),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12),
                      //         ),
                      //         textStyle: const TextStyle(
                      //             fontSize: 16, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //   ),
                      //   const SizedBox(height: 24),
                      // ],

                      // --- Go To Map Button ---
                      _buildGoToMapButton(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text("Error loading event: ${e.toString()}")),
      ),
    );
  }
}

Widget _buildInfoItemRounded({
  required IconData icon,
  required String title,
  required Color iconBackgroundColor,
  required Color iconColor,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    ],
  );
}

Widget _buildInfoItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color iconBackgroundColor,
  required Color iconColor,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildOrganizerItem({
  required String name,
  required String role,
  required String imageUrl,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 44,
              height: 44,
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 24),
            );
          },
        ),
      ),
      const SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildGoToMapButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        //AppNavigator.navigateToMapScreen(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GO TO MAP',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(100),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
