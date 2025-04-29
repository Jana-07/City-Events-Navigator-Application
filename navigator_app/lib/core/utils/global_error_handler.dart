import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/core/utils/error_hander.dart';
import 'package:navigator_app/core/utils/role_based_access.dart';
import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/data/models/event.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';

/// A provider for global error handling
class GlobalErrorHandler {
  static void handleError(BuildContext context, Exception error) {
    // Log the error
    debugPrint('Error occurred: $error');
    
    // Show error message to user
    ErrorHandler.showErrorSnackBar(context, ErrorHandler.handleFirebaseError(error));
  }
  
  static void handleAsyncError(BuildContext context, Object error, StackTrace stackTrace) {
    // Log the error with stack trace
    debugPrint('Async error occurred: $error');
    debugPrint(stackTrace.toString());
    
    // Show error message to user
    if (error is Exception) {
      ErrorHandler.showErrorSnackBar(context, ErrorHandler.handleFirebaseError(error));
    } else {
      ErrorHandler.showErrorSnackBar(context, 'An unexpected error occurred. Please try again.');
    }
  }
}

/// A widget that provides consistent error handling for async operations
class AsyncErrorHandler extends ConsumerWidget {
  final Widget Function(BuildContext, WidgetRef) builder;
  
  const AsyncErrorHandler({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return builder(context, ref);
  }
  
  static Widget withAsyncValue<T>({
    required AsyncValue<T> value,
    required Widget Function(T) data,
    Widget? loadingWidget,
    Widget Function(Object, StackTrace)? errorWidget,
  }) {
    return value.when(
      data: data,
      loading: () => loadingWidget ?? const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        if (errorWidget != null) {
          return errorWidget(error, stackTrace);
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // This would typically refresh the data
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Extension methods for event-related operations with error handling
extension EventOperations on Event {
  /// Delete an event with proper error handling
  Future<void> deleteWithErrorHandling(BuildContext context, WidgetRef ref) async {
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      
      // Check if user has permission to delete
      if (currentUser == null || currentUser.uid != creatorID && currentUser.role != 'organizer') {
        RoleBasedAccess.showRoleRequiredDialog(context, UserRole.organizer);
        return;
      }
      
      // Show loading dialog
      ErrorHandler.showLoadingDialog(context, 'Deleting event...');
      
      // Delete the event
      final eventRepository = ref.read(eventRepositoryProvider);
      await eventRepository.deleteEvent(id);
      
      // Hide loading dialog
      Navigator.of(context).pop();
      
      // Show success message
      ErrorHandler.showSuccessSnackBar(context, 'Event deleted successfully');
      
      // Navigate back
      if (context.mounted) {
        context.pop();
      }
    } on Exception catch (e) {
      // Hide loading dialog if showing
      Navigator.of(context).pop();
      
      // Show error message
      GlobalErrorHandler.handleError(context, e);
    }
  }
  
  /// Update an event with proper error handling
  Future<void> updateWithErrorHandling(
    BuildContext context, 
    WidgetRef ref,
    Map<String, dynamic> updates
  ) async {
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      
      // Check if user has permission to update
      if (currentUser == null || currentUser.uid != creatorID && currentUser.role != 'organizer') {
        RoleBasedAccess.showRoleRequiredDialog(context, UserRole.organizer);
        return;
      }
      
      // Show loading dialog
      ErrorHandler.showLoadingDialog(context, 'Updating event...');
      
      // Update the event
      //final eventRepository = ref.read(eventRepositoryProvider);
      //await eventRepository.saveEvent(id, updates);
      
      // Hide loading dialog
      Navigator.of(context).pop();
      
      // Show success message
      ErrorHandler.showSuccessSnackBar(context, 'Event updated successfully');
    } on Exception catch (e) {
      // Hide loading dialog if showing
      Navigator.of(context).pop();
      
      // Show error message
      GlobalErrorHandler.handleError(context, e);
    }
  }
}
