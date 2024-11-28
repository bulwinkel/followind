import 'package:flutter/widgets.dart';
import 'package:following_wind/src/colors.dart';
import 'package:following_wind/src/support_internal.dart';

import '../styler.dart';

class TextStyler implements Styler<Widget> {
  TextStyler({
    required this.colors,
  });

  final key = 'text';
  final Map<String, Map<int, Color>> colors;
  late final Map<String, double> _lookupSize = {
    '$key-xs': 12,
    '$key-sm': 14,
    '$key-base': 16,
    '$key-lg': 18,
    '$key-xl': 20,
    '$key-2xl': 24,
    '$key-3xl': 30,
    '$key-4xl': 36,
    '$key-5xl': 48,
    '$key-6xl': 60,
    '$key-7xl': 72,
    '$key-8xl': 96,
    '$key-9xl': 128,
  };

  late final _lookupColors = {
    '$key-white': white,
    '$key-black': black,
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        '$key-${color.key}-${shade.key}': shade.value,
  };

  final _lookupTextAlign = {
    'text-left': TextAlign.left,
    'text-center': TextAlign.center,
    'text-right': TextAlign.right,
    'text-justify': TextAlign.justify,
    'text-start': TextAlign.start,
    'text-end': TextAlign.end,
  };

  //TODO:KB 28/11/2024 support other text properties (look at properties of DefaultTextStyle)

  @override
  Widget apply(context, classes, widget) {
    // dpl('$key classes: ${[..._lookupColors.keys]}');

    Color? color;
    for (final entry in _lookupColors.entries) {
      if (classes.contains(entry.key)) {
        color = entry.value;
        break;
      }
    }

    TextAlign? textAlign;
    for (final entry in _lookupTextAlign.entries) {
      if (classes.contains(entry.key)) {
        textAlign = entry.value;
        break;
      }
    }

    double? size;
    for (final entry in _lookupSize.entries) {
      if (classes.contains(entry.key)) {
        size = entry.value;
        break;
      }
    }

    final applyIconStyle = color != null || size != null;
    final applyTextStyle = applyIconStyle || textAlign != null;

    if (applyTextStyle) {
      final parent = DefaultTextStyle.of(context);
      final style = parent.style;

      // TODO:KB 28/11/2024 how do we support height inheritance?
      // if it is not set then it defaults to the value defined
      // by the font
      final height = .95;
      dpl('height: $height');

      widget = DefaultTextStyle(
        style: TextStyle(
          color: color ?? style.color,
          fontSize: size ?? style.fontSize,
          // this removes unnecessary space at the top of the text
          height: height,
        ),
        textAlign: textAlign ?? parent.textAlign,
        child: widget,
      );
    }

    // doesn't make sense to color the font without coloring the icon
    if (applyIconStyle) {
      final parent = IconTheme.of(context);
      widget = IconTheme(
        data: IconThemeData(
          color: color ?? parent.color,
          // icons need to be a little bigger to look right
          size: size?.add(4) ?? parent.size,
        ),
        child: widget,
      );
    }

    return widget;
  }
}
