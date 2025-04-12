import 'package:flutter/material.dart';

/// A utility class for handling errors and displaying appropriate messages to users
class ErrorHandler {
  /// Shows a snackbar with an error message
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Shows a snackbar with a success message
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows a dialog with an error message and retry option
  static Future<bool> showErrorDialog(
    BuildContext context, 
    String title, 
    String message,
    {bool showRetry = true}
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          if (showRetry)
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
    
    return result ?? false;
  }

  /// Shows a loading dialog
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Hides the current dialog
  static void hideDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Formats Firebase error messages to be more user-friendly
  static String formatFirebaseError(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or try signing in.';
      case 'invalid-email':
        return 'The email address is not valid. Please enter a valid email.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'user-not-found':
        return 'No user found with this email. Please check your email or sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again or reset your password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'too-many-requests':
        return 'Too many unsuccessful attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';
      case 'permission-denied':
        return 'You don\'t have permission to perform this action.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'A resource with this ID already exists.';
      case 'resource-exhausted':
        return 'You have exceeded your quota. Please try again later.';
      default:
        return 'An error occurred: $errorCode';
    }
  }

  /// Handles common Firebase errors and returns a user-friendly message
  static String handleFirebaseError(dynamic error) {
    if (error is Exception) {
      final errorMessage = error.toString();
      
      // Extract error code from Firebase error message
      final RegExp regExp = RegExp(r'\[(.*?)\]');
      final match = regExp.firstMatch(errorMessage);
      
      if (match != null && match.groupCount >= 1) {
        final errorCode = match.group(1);
        if (errorCode != null) {
          return formatFirebaseError(errorCode);
        }
      }
      
      // If we couldn't extract an error code, return a generic message
      if (errorMessage.contains('network')) {
        return 'Network error. Please check your internet connection and try again.';
      } else if (errorMessage.contains('permission')) {
        return 'You don\'t have permission to perform this action.';
      } else if (errorMessage.contains('not found')) {
        return 'The requested resource was not found.';
      }
    }
    
    return 'An unexpected error occurred. Please try again later.';
  }
}
