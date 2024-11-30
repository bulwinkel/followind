import 'package:flutter/widgets.dart';
import 'package:following_wind/src/support_internal.dart';

import '../colors.dart';

class FwDefaultTextAndIconStyle extends StatelessWidget {
  FwDefaultTextAndIconStyle({
    super.key,
    required this.spacingMultiplier,
    this.classKey = 'text',
    required this.findValueForClass,
    required this.colors,
    required this.child,
  });

  final double spacingMultiplier;
  final String classKey;
  final T Function<T>(
    Map<String, T> lookup,
    T defaultValue,
  ) findValueForClass;
  final Widget child;

  final Map<String, Map<int, Color>> colors;
  late final Map<String, double> _lookupSize = {
    '$classKey-xs': 12,
    '$classKey-sm': 14,
    '$classKey-base': 16,
    '$classKey-lg': 18,
    '$classKey-xl': 20,
    '$classKey-2xl': 24,
    '$classKey-3xl': 30,
    '$classKey-4xl': 36,
    '$classKey-5xl': 48,
    '$classKey-6xl': 60,
    '$classKey-7xl': 72,
    '$classKey-8xl': 96,
    '$classKey-9xl': 128,
  };

  late final _lookupColors = {
    '$classKey-white': white,
    '$classKey-black': black,
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        '$classKey-${color.key}-${shade.key}': shade.value,
  };

  final _lookupTextAlign = {
    'text-left': TextAlign.left,
    'text-center': TextAlign.center,
    'text-right': TextAlign.right,
    'text-justify': TextAlign.justify,
    'text-start': TextAlign.start,
    'text-end': TextAlign.end,
  };

  @override
  Widget build(BuildContext context) {
    Widget widget = child;

    Color? color = findValueForClass(_lookupColors, null);
    TextAlign? textAlign = findValueForClass(_lookupTextAlign, null);
    double? size = findValueForClass(_lookupSize, null);

    final applyIconStyle = color != null || size != null;
    final applyTextStyle = applyIconStyle || textAlign != null;

    if (applyTextStyle) {
      final parent = DefaultTextStyle.of(context);
      final style = parent.style;

      // TODO:KB 28/11/2024 how do we support height inheritance?
      // if it is not set then it defaults to the value defined
      // by the font
      final height = .95;
      // dpl('height: $height');

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
