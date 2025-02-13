import 'package:flutter/widgets.dart';
import 'package:following_wind/following_wind.dart';

part "padding.dart";
part "margin.dart";
part "flex.dart";
part "size_class.dart";
part "flexible.dart";
part "decorated_box.dart";
sealed class Style {
  const Style();
}

extension StyleListX on List<Style> {
  /// Requires [Style]s to be sorted by [SizeClass], smallest to largest
  /// for the overriding behavior to work correctly.
  Iterable<T> unpack<T extends Style>(FollowingWindData fw) sync* {
    for (final style in this) {
      if (style is T) yield style;

      if (style is SizeClassStyle &&
          style.style is T &&
          fw.screenSize.width >= fw.sizeForClass(style.sizeClass)) {
        yield style.style as T;
      }
    }
  }
}
