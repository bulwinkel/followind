import 'package:flutter/foundation.dart';

extension MaybeDoubleX on double? {
  double? add(double other) {
    if (this == null) return null;
    return this! + other;
  }
}

void dpl(String message) {
  if (kDebugMode) print(message);
}

/// Bottom, Left, Right, Top
typedef BLRT<T> = (T? b, T? l, T? r, T? t);

// Using same parameter names as EdgeInsets to make it easy to find and replace
BLRT<T> blrtAll<T>(T? value) => (value, value, value, value);

BLRT<T> blrtSymmetric<T>({T? vertical, T? horizontal}) =>
    (vertical, horizontal, horizontal, vertical);

BLRT<T> blrtOnly<T>({T? bottom, T? left, T? right, T? top}) =>
    (bottom, left, right, top);

/// Efficiently collect classes from a string into a map
/// Reduces the number of allocations and string operations
List<String> collectClasses(String className, List<String> classNames) {
  final result = <String>[];
  final buffer = StringBuffer();

  final initialStringCount = classNames.length + 1;

  for (var i = 0; i < initialStringCount; i += 1) {
    final str = i == 0 ? className : classNames[i - 1];
    for (var j = 0; j < str.length; j += 1) {
      // if it's a space or the end of the string
      // write the contents of the buffer to the result
      final char = str[j];
      final isGap = char == ' ';
      if (isGap && buffer.length > 0) {
        result.add(buffer.toString());
        buffer.clear();
      } else if (!isGap) {
        buffer.write(char);
      }
    }

    // if the buffer is not empty, write it to the result
    if (buffer.length > 0) {
      result.add(buffer.toString());
      buffer.clear();
    }
  }

  return result;
}
