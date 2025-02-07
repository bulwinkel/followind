import 'package:flutter/widgets.dart';
import 'package:following_wind/following_wind.dart';
import 'package:following_wind/src/size_class.dart';

part "padding.dart";
part "flex.dart";
part "size_class.dart";

sealed class Style {
  const Style();
}

extension StyleListX on List<Style> {
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
