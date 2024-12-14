abstract interface class Parser<T> {
  /// return true if the class was processed / consumed
  bool parse(String className);

  T? get result;
}
