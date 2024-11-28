import 'package:flutter/widgets.dart';

abstract interface class Styler<T> {
  T apply(BuildContext context, List<String> classes, T widget);
}
