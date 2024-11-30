import 'package:flutter/widgets.dart';
import 'package:following_wind/src/widgets/fw_default_text_and_icon_style.dart';
import 'package:following_wind/src/widgets/fw_size.dart';

import 'class_groups.dart';
import 'colors.dart';
import 'parsers/border.dart';
import 'parsers/edge_insets.dart';
import 'spacings.dart';
import 'support_internal.dart';
import 'widgets/fw_flex.dart';

// ignore: camel_case_types
class Box extends StatelessWidget {
  const Box({
    super.key,
    this.className = '',
    this.classNames = const [],
    this.conditionals = const {},
    this.onPressed,
    this.children = const [],
  });

  final String className;
  final List<String> classNames;
  final Map<bool, String> conditionals;
  final List<Widget> children;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final classMap = {
      for (final c in className.split(' ')) c: c,
      for (final cn in classNames)
        for (final c in cn.split(' ')) c: c,
      for (final entry in conditionals.entries)
        if (entry.key) entry.value: entry.value,
    };
    // dpl('classes: $classMap');

    if (classMap.containsKey('hidden')) {
      return const SizedBox.shrink();
    }

    T findValueForClass<T>(
      Map<String, T> lookup,
      T defaultValue,
    ) {
      T? result;

      for (final className in lookup.keys) {
        final value = classMap[className];
        if (value != null) {
          result = lookup[className];
          break;
        }
      }

      return result ?? defaultValue;
    }

    // Group classes by their type
    final classes = classMap.keys.toList();
    final classGroups = ClassGroups.fromClasses(classes);

    // Configure the layout first by processing all layout classes together
    Widget child = FwFlex(
      spacingMultiplier: spacingMultiplier,
      spacings: spacings.keys.toList(),
      findValueForClass: findValueForClass,
      children: children,
    );

    // Apply text styles
    child = FwDefaultTextAndIconStyle(
      spacingMultiplier: spacingMultiplier,
      classKey: 'text',
      findValueForClass: findValueForClass,
      colors: colors,
      child: child,
    );

    // internal spacing
    final paddingInsets = edgeInsetsParser.parse(classes);
    // dpl('paddingInsets: $paddingInsets');

    if (paddingInsets != null) {
      child = Padding(
        padding: paddingInsets,
        child: child,
      );
    }

    child = _applyVisualClasses(classGroups.visual, child);

    // no prefix yet
    final spacingsCalculated = {
      for (final entry in spacings.entries)
        entry.key: entry.value * spacingMultiplier,
    };

    // calculate fractional sizes
    final screenSize = MediaQuery.sizeOf(context);
    // dpl("screenSize: $screenSize");

    final fractionalWidthsCalculated = {
      'full': double.infinity,
      for (final entry in fractionalSizes.entries)
        entry.key: entry.value * screenSize.width,
    };
    // dpl('fractionalWidthsCalculated: $fractionalWidthsCalculated');

    final Map<String, double> fractionalHeightsCalculated = {
      'full': double.infinity,
      for (final entry in fractionalSizes.entries)
        entry.key: entry.value * screenSize.height,
    };

    final Map<String, Size> fractionalSizesCalculated = {
      'full': Size(double.infinity, double.infinity),
      for (final entry in fractionalSizes.entries)
        entry.key: Size(
          entry.value * screenSize.width,
          entry.value * screenSize.height,
        ),
    };

    // lookups

    final Map<String, Size> lookupSize = {
      for (final entry in spacingsCalculated.entries)
        'size-${entry.key}': Size(entry.value, entry.value),
      for (final entry in fractionalSizesCalculated.entries)
        'size-${entry.key}': entry.value,
    };

    final Map<String, double> lookupHeight = {
      for (final entry in spacingsCalculated.entries)
        'h-${entry.key}': entry.value,
      for (final entry in fractionalHeightsCalculated.entries)
        'h-${entry.key}': entry.value,
    };

    final Map<String, double> lookupWidth = {
      for (final entry in spacingsCalculated.entries)
        'w-${entry.key}': entry.value,
      for (final entry in fractionalWidthsCalculated.entries)
        'w-${entry.key}': entry.value,
    };

    // Size the box before applying external spacing
    child = FwSize(
      lookupSize: lookupSize,
      lookupHeight: lookupHeight,
      lookupWidth: lookupWidth,
      findValueForClass: findValueForClass,
      child: child,
    );

    if (onPressed != null) {
      child = GestureDetector(
        onTap: onPressed,
        child: child,
      );
    }

    final marginInsets = edgeInsetsParser.parse(classGroups.margin);
    if (marginInsets != null) {
      child = Padding(
        padding: marginInsets,
        child: child,
      );
    }

    return child;
  }
}

Widget box(
  String className,
  List<Widget> children, {
  Key? key,
}) {
  return Box(
    key: key,
    className: className,
    children: children,
  );
}

const spacingMultiplier = 4.0;

final borderParser = BorderParser(
  widths: ['0', '1', '2', '4', '8'],
  widthDefault: 1.0,
  colors: colors,
  colorDefault: colors['gray']![200]!,
);

final edgeInsetsParser = EdgeInsetsParser(
  spacings: spacings.keys.toList(),
  multiplier: spacingMultiplier,
);

Widget _applyVisualClasses(List<String> cs, Widget child) {
  // dpl('cs: $cs');
  if (cs.isEmpty) return child;

  Color? bgColor;
  BorderRadius borderRadius = BorderRadius.zero;

  Border? border = borderParser.parse(cs);
  // dpl('border: $border');

  for (final c in cs) {
    final parts = c.split('-');
    final key = parts[0];

    switch (key) {
      case 'bg':
        bgColor = _colorFrom(parts.sublist(1));
        break;
      // Handles multiple radius classes
      // e.g. rounded-tl-md rounded-br-lg
      // NOTE:KB 24/11/2024 full doesn't work with multiple classes
      // e.g. rounded-t-full rounded-lg
      // after full is applied, the rest are ignored
      // this appears to be an issue in flutter itself
      case 'rounded':
        final nextRadius = _borderRadiusFrom(parts.sublist(1));
        // dpl('nextRadius: $nextRadius');
        borderRadius = borderRadius.copyWith(
          topLeft:
              nextRadius.topLeft == Radius.zero ? null : nextRadius.topLeft,
          topRight:
              nextRadius.topRight == Radius.zero ? null : nextRadius.topRight,
          bottomRight: nextRadius.bottomRight == Radius.zero
              ? null
              : nextRadius.bottomRight,
          bottomLeft: nextRadius.bottomLeft == Radius.zero
              ? null
              : nextRadius.bottomLeft,
        );
        break;
    }
  }

  // dpl('borderRadius: $borderRadius');

  return DecoratedBox(
    decoration: BoxDecoration(
      color: bgColor,
      border: border,
      borderRadius: borderRadius,
    ),
    child: child,
  );
}

Color? _colorFrom(List<String> parts) {
  final colorName = parts[0];
  switch (colorName) {
    case 'white':
      return const Color(0xFFFFFFFF);
    case 'black':
      return const Color(0xFF000000);
    default:
      final colorRange = colors[colorName];
      if (colorRange == null) {
        // dpl('Unknown color: $colorName');
        return null;
      }

      String? colorVariantName;
      if (parts.length > 1) {
        colorVariantName = parts[1];
      }

      if (colorVariantName == null) {
        // dpl('No color variant specified for $colorName');
        return null;
      }

      final int? colorVariant = int.tryParse(colorVariantName);
      if (colorVariant == null) {
        // dpl('Invalid color variant specified for $colorName: $colorVariantName');
        return null;
      }

      final color = colorRange[colorVariant];
      if (color == null) {
        // dpl('Unknown color variant $colorVariant for $colorName');
      }
      return color;
  }
}

BorderRadius _borderRadiusFrom(List<String> parts) {
  if (parts.isEmpty) {
    return const BorderRadius.all(
      Radius.circular(spacingMultiplier),
    );
  }

  if (parts.length == 1) {
    // first part could be a size class or a specific edge / corner
    final radius = _radiusForSizeClass(parts.first);
    if (radius != null) {
      return BorderRadius.circular(radius);
    }
  }

  // e.g. tl || tl-md

  double? topLeft;
  double? topRight;
  double? bottomRight;
  double? bottomLeft;

  switch (parts.first) {
    // rounded-t-{size} - Top corners
    case 't':
      topLeft = topRight = _radiusForSizeClass(parts[1]);
      break;
    // rounded-r-{size} - Right corners
    case 'r':
      topRight = bottomRight = _radiusForSizeClass(parts[1]);
      break;
    // rounded-b-{size} - Bottom corners
    case 'b':
      bottomRight = bottomLeft = _radiusForSizeClass(parts[1]);
      break;
    // rounded-l-{size} - Left corners
    case 'l':
      bottomLeft = topLeft = _radiusForSizeClass(parts[1]);
      break;

    // rounded-tl-{size} - Top left corner
    case 'tl':
      topLeft = _radiusForSizeClass(parts[1]);
      break;
    // rounded-tr-{size} - Top right corner
    case 'tr':
      topRight = _radiusForSizeClass(parts[1]);
      break;
    // rounded-br-{size} - Bottom right corner
    case 'br':
      bottomRight = _radiusForSizeClass(parts[1]);
      break;
    // rounded-bl-{size} - Bottom left corner
    case 'bl':
      bottomLeft = _radiusForSizeClass(parts[1]);
      break;
    default:
      // dpl('Unknown corner: ${parts.first}');
      return BorderRadius.zero;
  }

  return BorderRadius.only(
    topLeft: Radius.circular(topLeft ?? 0),
    topRight: Radius.circular(topRight ?? 0),
    bottomRight: Radius.circular(bottomRight ?? 0),
    bottomLeft: Radius.circular(bottomLeft ?? 0),
  );
}

// Where {size} can be any of:
//
// none
// sm (0.125rem / 2px)
// DEFAULT (0.25rem / 4px)
// md (0.375rem / 6px)
// lg (0.5rem / 8px)
// xl (0.75rem / 12px)
// 2xl (1rem / 16px)
// 3xl (1.5rem / 24px)
// full (9999px)
double? _radiusForSizeClass(String sizeClass) {
  return switch (sizeClass) {
    'sm' => spacingMultiplier,
    'md' => spacingMultiplier * 1.5,
    'lg' => spacingMultiplier * 2,
    'xl' => spacingMultiplier * 3,
    '2xl' => spacingMultiplier * 4,
    '3xl' => spacingMultiplier * 6,
    'full' => 9999.0,
    'none' => 0.0,
    _ => null,
  };
}
