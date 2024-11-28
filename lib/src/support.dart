extension JoinedClassNames on List<String> {
  String get joined {
    return this.join(" ");
  }
}

String merge(
  String classNames, {
  List<String> and = const [],
  Map<bool, String> maybe = const {},
}) {
  final builder = StringBuffer(classNames);

  for (final it in and) {
    builder.write(" ");
    builder.write(it);
  }

  for (final entry in maybe.entries) {
    if (entry.key) {
      builder.write(" ");
      builder.write(entry.value);
    }
  }

  return builder.toString();
}
