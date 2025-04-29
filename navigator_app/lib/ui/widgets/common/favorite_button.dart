import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/data/models/favorite.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';
import 'package:navigator_app/ui/controllers/favorite_controller.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    super.key,
    required this.eventId,
    required this.address,
    required this.title,
    required this.imageURL,
    required this.date,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
  });

  final String eventId;
  final String title;
  final String address;
  final String imageURL;
  final DateTime date;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the favorite status for this specific event
    final favoriteStatusAsync =
        ref.watch(eventFavoriteStatusProvider(eventId));

    return favoriteStatusAsync.when(
      data: (isFavorite) => _buildButton(context, ref, isFavorite),
      loading: () => _buildLoadingIndicator(),
      error: (_, __) => _buildButton(context, ref, false),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 35,
      height: 35,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, WidgetRef ref, bool isFavorite) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _toggleFavorite(context, ref, isFavorite),
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withAlpha(200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite
              ? (activeColor ?? theme.colorScheme.primary)
              : (inactiveColor ?? Colors.grey),
          size: size,
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(
      BuildContext context, WidgetRef ref, bool currentStatus) async {
    // Optimistic update - immediately update all instances
    ref
        .read(eventFavoriteStatusProvider(eventId).notifier)
        .setStatus(!currentStatus);

    try {
      // Perform the actual toggle operation
      final eventRef = ref.read(eventRepositoryProvider).eventRef(eventId);
      await ref.read(favoriteControllerProvider.notifier).toggleFavorite(
            event: FavoriteEvent(
                id: eventId,
                addedAt: DateTime.now(),
                address: address,
                imageURL: imageURL,
                eventRef: eventRef,
                startDate: date,
                title: title),
            context: context,
          );

    } catch (e) {
      // Revert on error
      ref
          .read(eventFavoriteStatusProvider(eventId).notifier)
          .setStatus(currentStatus);

      // Show error if needed
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating favorite: ${e.toString()}')),
        );
      }
    }
  }
}
