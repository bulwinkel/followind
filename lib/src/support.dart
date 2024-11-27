import 'package:flutter/foundation.dart';

void dpl(String message) {
  if (kDebugMode) print(message);
}

typedef BLRT<T> = (T? b, T? l, T? r, T? t);

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
