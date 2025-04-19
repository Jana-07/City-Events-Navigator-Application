import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/data/category_data.dart';
import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/data/models/categoy.dart';
import 'package:navigator_app/data/repositories/user_repository.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/ui/widgets/common/favorite_button.dart';
import '../../../data/models/event.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  final Event event;

  const EventDetailsScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  ConsumerState<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends ConsumerState<EventDetailsScreen> {
  late Future<AppUser?> _organizer;

  @override
  void initState() {
    final userRepository = ref.read(userRepositoryProvider);
    _organizer = userRepository.getUser(widget.event.creatorID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final category = categories.firstWhere(
      (category) => category.name == widget.event.category,
      orElse: () => Category(
        name: 'Other',
        icon: Icons.help_outline,
        color: Colors.grey,
      ),
    );
    return Scaffold(
      body: FutureBuilder<AppUser?>(
        future: _organizer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final organizer = snapshot.data;
          if (organizer == null) {
            return const Center(child: Text('Organizer not found'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.event.imageURL,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child:
                                const Icon(Icons.image_not_supported, size: 50),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(180),
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
                actions: const [
                  FavoriteButton(),
                ],
                actionsPadding: const EdgeInsets.all(10),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.event.title,
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 24),
                      _buildInfoItem(
                        icon: Icons.calendar_today,
                        title: DateFormat('d MMMM, yyyy')
                            .format(widget.event.startDate),
                        subtitle:
                            '${DateFormat('h:mm a').format(widget.event.startDate)} - ${DateFormat('h:mm a').format(widget.event.endDate)}',
                        iconBackgroundColor: Colors.green.withAlpha(25),
                        iconColor: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItem(
                        icon: Icons.location_on,
                        title: widget.event.address,
                        subtitle: widget.event.address,
                        iconBackgroundColor: Colors.green.withAlpha(25),
                        iconColor: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      _buildOrganizerItem(
                        name: organizer.userName,
                        role: 'Organizer',
                        imageUrl: organizer.profilePhotoURL,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'About Event',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: widget.event.averageRating,
                            itemCount: 5,
                            itemSize: 20,
                            direction: Axis.horizontal,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rate_rounded,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.event.averageRating.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.event.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          _buildInfoItemRounded(
                            icon: Icons.attach_money_rounded,
                            iconBackgroundColor: Colors.black.withAlpha(25),
                            iconColor: Colors.black,
                            title: widget.event.price == 0
                                ? 'Free'
                                : widget.event.price.toString(),
                          ),
                          const SizedBox(width: 30),
                          _buildInfoItemRounded(
                            icon: category.icon,
                            iconBackgroundColor: category.color.withAlpha(200),
                            iconColor: Colors.white,
                            title: category.name,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildGoToMapButton(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
