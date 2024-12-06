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

typedef Corners<T> = (T? bl, T? br, T? tl, T? tr);

Corners<T> cornersAll<T>(T? value) => (value, value, value, value);

Corners<T> cornersTop<T>(T? value) => (null, null, value, value);

Corners<T> cornersBottom<T>(T? value) => (value, value, null, null);

Corners<T> cornersLeft<T>(T? value) => (value, null, value, null);

Corners<T> cornersRight<T>(T? value) => (null, value, null, value);

Corners<T> cornersOnly<T>(
        {T? bottomLeft, T? bottomRight, T? topLeft, T? topRight}) =>
    (bottomLeft, bottomRight, topLeft, topRight);

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

List<String> findResponsiveModifiers(
  double screenWidth,
  Map<String, double> responsiveModifiers,
) {
  final List<String> prefixes = [];

  for (final entries in responsiveModifiers.entries) {
    final modifier = entries.key;
    final value = entries.value;

    if (screenWidth >= value) {
      prefixes.add(modifier);
    }
  }

  // dpl('prefixes: $prefixes');
  return prefixes;
}

typedef ParsedClass = ({
  double sortOrder,
  String value,
  String type,
  double applyAtWidth,
});

List<ParsedClass> parseClasses({
  required List<String> classes,

  /// The classes we are parsing in order
  required List<String> classTypes,
  required Map<String, double> sizeClasses,
}) {
  final List<ParsedClass> parsedClasses = [];

  // parse into its parts (split by `:` for prefixes, then by `-` for the segments)
  for (final c in classes) {
    final prefixes = c.split(':');
    final classWithoutPrefixes = prefixes.removeLast();

    // dpl('prefixes: $prefixes');

    // make sure this is one of the classes we are looking for
    String? type;
    String? value;
    for (final classType in classTypes) {
      // dpl('classType: $classType, classWithoutPrefixes: $classWithoutPrefixes');
      if (classWithoutPrefixes.startsWith("$classType-")) {
        type = classType;
        value = classWithoutPrefixes.substring(classType.length + 1);
        break;
      }
    }

    // dpl('type: $type, value: $value');

    if (type == null || value == null) {
      continue;
    }

    // 0 if no responsive modifier
    var applyAtWidth = 0.0;
    for (final prefix in prefixes) {
      applyAtWidth = sizeClasses[prefix] ?? 0.0;
      if (applyAtWidth != 0.0) {
        break;
      }
    }

    // encode the classSegmentsInOrder into this class
    // get the classSegmentsInOrder from the classSegmentsInOrder array
    // then add the applyAtWidth
    // then we have a single value to sort by
    final parsed = (
      sortOrder: classTypes.indexOf(type) + applyAtWidth, // 0, 1, 769
      // calculate the blrt values
      value: value, // 1, 2, ...
      type: type, // p, px, py, ...
      applyAtWidth: applyAtWidth
    );
    parsedClasses.add(parsed);
  }

  // sort the list: use the sortOrder value
  parsedClasses.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  return parsedClasses;
}
