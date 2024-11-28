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
