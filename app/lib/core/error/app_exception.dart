class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});
  
  factory AppException.network() => AppException("Network error. Please check your connection.", code: "network");
  factory AppException.server() => AppException("Server error. Please try again later.", code: "server");
  factory AppException.unauthorized() => AppException("Unauthorized. Please log in again.", code: "unauthorized");
  factory AppException.unknown([String? msg]) => AppException(msg ?? "An unknown error occurred.", code: "unknown");

  @override
  String toString() => message;
}
