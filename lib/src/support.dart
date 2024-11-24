import 'package:flutter/foundation.dart';

void dpl(String message) {
  if (kDebugMode) print(message);
}

extension JoinedClassNames on List<String> {
  String get joined {
    return join(" ");
  }
}
