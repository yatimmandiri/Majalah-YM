class TimeoutException implements Exception {
  final String message;
  TimeoutException([this.message = "Request timed out"]);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException([this.message = "Resource not found"]);
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Server error"]);
}

class UnknownException implements Exception {
  final String message;
  UnknownException([this.message = "An unknown error occurred"]);
}
