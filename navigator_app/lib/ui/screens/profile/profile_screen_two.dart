import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/data/models/favorite.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';

class ProfileScreenTwo extends ConsumerWidget {
  const ProfileScreenTwo({super.key});
  String _formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserAsync = ref.watch(authStateChangesProvider);

    return currentUserAsync.when(
      data: (user) {
        if (user == null || user.uid == 'guest') {
          return _buildSignInPrompt(context);
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(user.userName),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      user.profilePhotoURL.isNotEmpty
                          ? Image.network(
                              user.profilePhotoURL,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: theme.primaryColor),
                            )
                          : Container(color: theme.primaryColor),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to edit profile screen
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(context, user),
                      const SizedBox(height: 24),
                      _buildSectionHeader(context, 'My Interests'),
                      const SizedBox(height: 8),
                      _buildInterestsList(context, user.preferences),
                    ],
                  ),
                ),
              ),
              _buildHostedEventsSection(context, ref, user),
              _buildFavoritesSection(context, ref, user),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Sign in to view your profile',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppUser user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(user.email),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Role'),
              subtitle: Text(user.role.toUpperCase()),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Preferred Language'),
              subtitle: Text(user.preferredLanguage),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInterestsList(BuildContext context, List<String> interests) {
    if (interests.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('No interests added yet'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: interests.map((interest) {
        return Chip(
          label: Text(interest),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        );
      }).toList(),
    );
  }

  Widget _buildHostedEventsSection(
      BuildContext context, WidgetRef ref, AppUser user) {
    if (user.eventsHosted.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'Hosted Events'),
              const SizedBox(height: 16),
              const Center(child: Text('You haven\'t hosted any events yet')),
              const SizedBox(height: 16),
              if (user.role == 'organizer')
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create Event'),
                    onPressed: () {
                      // Navigate to create event screen
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(context, 'Hosted Events'),
                if (user.role == 'organizer')
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create'),
                    onPressed: () {
                      // Navigate to create event screen
                    },
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: _buildHostedEventsList(context, ref, user.eventsHosted),
          ),
        ],
      ),
    );
  }

  Widget _buildHostedEventsList(
      BuildContext context, WidgetRef ref, List<String> eventIds) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: eventIds.length,
      itemBuilder: (context, index) {
        final eventId = eventIds[index];
        return _buildEventCard(context, ref, eventId);
      },
    );
  }

  Widget _buildEventCard(BuildContext context, WidgetRef ref, String eventId) {
    return FutureBuilder<Event?>(
      future: ref.read(eventRepositoryProvider).getEvent(eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 280,
            child: Card(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const SizedBox(
            width: 280,
            child: Card(
              child: Center(child: Text('Event not found')),
            ),
          );
        }

        final event = snapshot.data!;
        return SizedBox(
          width: 280,
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(right: 16, bottom: 8),
            child: InkWell(
              onTap: () {
                context.push('/event-details/${event.id}');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: event.imageURL.isNotEmpty
                        ? Image.network(
                            event.imageURL,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 50),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 50),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.address,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(event.startDate),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesSection(
      BuildContext context, WidgetRef ref, AppUser user) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: _buildSectionHeader(context, 'Favorite Events'),
          ),
          SizedBox(
            height: 220,
            child: _buildFavoritesList(context, ref, user.uid),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(
      BuildContext context, WidgetRef ref, String userId) {
    return StreamBuilder<List<Favorite>>(
        stream: ref.read(userRepositoryProvider).streamUserFavorites(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final favorites = snapshot.data ?? [];

          if (favorites.isEmpty) {
            return const Center(
              child: Text('No favorite events yet'),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return SizedBox(
                width: 280,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(right: 16, bottom: 8),
                  child: InkWell(
                    onTap: () {
                      // Extract event ID from reference path
                      final eventId = favorite.eventRef.id;
                      context.push('/event-details/$eventId');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: favorite.eventImageURL.isNotEmpty
                              ? Image.network(
                                  favorite.eventImageURL,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 50),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 50),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favorite.eventTitle,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                favorite.eventAddress,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(favorite.eventStartDate),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
