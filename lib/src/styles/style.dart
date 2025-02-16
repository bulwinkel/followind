import 'package:flutter/widgets.dart';
import 'package:followind/followind.dart';

part "align.dart";

part "decorated_box.dart";

part "flex.dart";

part "flexible.dart";

part "margin.dart";

part "modifier.dart";

part "padding.dart";

part "size.dart";

part "text.dart";

sealed class Style {
  const Style();
}

extension StyleListX on List<Style> {
  /// Requires [Style]s to be sorted by [SizeClass], smallest to largest
  /// for the overriding behavior to work correctly.
  Iterable<T> unpack<T extends Style>(FollowindData fw, bool isHovered) sync* {
    for (final style in this) {
      if (style is T) yield style;

      if (style is ModifierStyle &&
          style.style is T &&
          fw.screenSize.width >= fw.sizeForClass(style.sizeClass) &&
          // if style.hover == null then ignore isHovered
          // if style.hover == true then only yield if isHovered
          (style.hover == null || style.hover == isHovered)) {
        yield style.style as T;
      }
    }
  }
}
