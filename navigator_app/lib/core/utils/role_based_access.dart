import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';

/// A utility class for role-based access control
class RoleBasedAccess {
  /// Check if the current user has the required role
  static bool hasRole(WidgetRef ref, UserRole requiredRole) {
    final userRoleStream = ref.watch(userRoleProvider);
    
    return userRoleStream.when(
      data: (role) {
        switch (requiredRole) {
          case UserRole.organizer:
            return role == 'organizer';
          case UserRole.user:
            return role == 'user' || role == 'organizer';
          case UserRole.guest:
            return true; // Everyone has at least guest access
        }
      },
      loading: () => false,
      error: (_, __) => false,
    );
  }
  
  /// Widget that only shows its child if the user has the required role
  static Widget roleGuard({
    required WidgetRef ref,
    required UserRole requiredRole,
    required Widget child,
    Widget? fallback,
  }) {
    final userRoleStream = ref.watch(userRoleProvider);
    
    return userRoleStream.when(
      data: (role) {
        bool hasAccess = false;
        
        switch (requiredRole) {
          case UserRole.organizer:
            hasAccess = role == 'organizer';
            break;
          case UserRole.user:
            hasAccess = role == 'user' || role == 'organizer';
            break;
          case UserRole.guest:
            hasAccess = true; // Everyone has at least guest access
            break;
        }
        
        if (hasAccess) {
          return child;
        } else {
          return fallback ?? const SizedBox.shrink();
        }
      },
      loading: () => fallback ?? const Center(child: CircularProgressIndicator()),
      error: (_, __) => fallback ?? const SizedBox.shrink(),
    );
  }
  
  /// Show a dialog if the user doesn't have the required role
  static void showRoleRequiredDialog(
    BuildContext context, 
    UserRole requiredRole,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Access Restricted'),
        content: Text(
          'You need to be a ${_roleToString(requiredRole)} to access this feature. '
          'Would you like to sign up or log in?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login screen
              // TODO: Implement navigation to login screen
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }
  
  /// Convert UserRole enum to string
  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.organizer:
        return 'organizer';
      case UserRole.user:
        return 'registered user';
      case UserRole.guest:
        return 'guest';
    }
  }
}
