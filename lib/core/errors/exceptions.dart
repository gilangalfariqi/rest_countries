abstract class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppException(this.message, {this.code, this.stackTrace});

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

class ServerException extends AppException {
  const ServerException(String message, {String? code, StackTrace? stackTrace})
      : super(message, code: code, stackTrace: stackTrace);
}

class CacheException extends AppException {
  const CacheException(String message, {String? code, StackTrace? stackTrace})
      : super(message, code: code, stackTrace: stackTrace);
}

class NetworkException extends AppException {
  const NetworkException(String message, {String? code, StackTrace? stackTrace})
      : super(message, code: code, stackTrace: stackTrace);
}

class ValidationException extends AppException {
  const ValidationException(String message, {String? code, StackTrace? stackTrace})
      : super(message, code: code, stackTrace: stackTrace);
}

class UnknownException extends AppException {
  const UnknownException(String message, {String? code, StackTrace? stackTrace})
      : super(message, code: code, stackTrace: stackTrace);
}