import 'package:flutter/foundation.dart';

extension MaybeDoubleX on double? {
  double? add(double other) {
    if (this == null) return null;
    return this! + other;
  }
}

void dp(String message) {
  if (kDebugMode) print(message);
}
