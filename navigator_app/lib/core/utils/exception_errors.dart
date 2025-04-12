class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});
  
  @override
  String toString() => message;

  factory AuthException.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return EmailAlreadyInUseException();
      case 'invalid-email':
        return InvalidEmailException();
      case 'weak-password':
        return WeakPasswordException();
      case 'user-not-found':
        return UserNotFoundException();
      case 'wrong-password':
        return WrongPasswordException();
      case 'network-request-failed':
        return NetworkException();
      default:
        return AuthException('An unknown error occurred', code: code);
    }
  }
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super('Email is already in use');
}

class InvalidEmailException extends AuthException {
  InvalidEmailException() : super('Invalid email format');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException() : super('Password is too weak');
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('User not found');
}

class WrongPasswordException extends AuthException {
  WrongPasswordException() : super('Wrong password');
}

class NetworkException extends AuthException {
  NetworkException() : super('Network error occurred');
}
