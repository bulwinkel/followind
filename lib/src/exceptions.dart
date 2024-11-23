class FWException implements Exception {
  final String message;

  FWException(this.message);

  @override
  String toString() {
    return '$runtimeType: $message';
  }
}

class FWUnknownClassException extends FWException {
  FWUnknownClassException(super.message);
}
