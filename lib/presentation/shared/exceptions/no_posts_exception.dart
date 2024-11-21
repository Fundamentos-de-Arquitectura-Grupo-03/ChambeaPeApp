class NoPostsException implements Exception {
  final String message;
  NoPostsException([this.message = "Error: El empleador no tiene ninguna publicación activa."]);

  @override
  String toString() => message;
}