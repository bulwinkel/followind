import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:following_wind/src/support.dart';

import 'class_groups.dart';
import 'colors.dart';
import 'exceptions.dart';

typedef ApplyClassName = Widget Function(Widget child, List<String> parts);

class ClassParser {
  static const spacingMultiplier = 4;

  // TODO: handle custom values in [] brackets, e.g. [24px]
  final Map<String, ApplyClassName> classNameLookup = {
    // region Padding
    'p': (child, parts) {
      return Padding(
        padding: EdgeInsets.all(parseToSpacing(parts)),
        child: child,
      );
    },
    'px': (child, parts) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: parseToSpacing(parts)),
        child: child,
      );
    },
    'py': (child, parts) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: parseToSpacing(parts)),
        child: child,
      );
    },
    'pb': (child, parts) {
      return Padding(
        padding: EdgeInsets.only(bottom: parseToSpacing(parts)),
        child: child,
      );
    },
    'pt': (child, parts) {
      return Padding(
        padding: EdgeInsets.only(top: parseToSpacing(parts)),
        child: child,
      );
    },
    'pl': (child, parts) {
      return Padding(
        padding: EdgeInsets.only(left: parseToSpacing(parts)),
        child: child,
      );
    },
    'pr': (child, parts) {
      return Padding(
        padding: EdgeInsets.only(right: parseToSpacing(parts)),
        child: child,
      );
    },
    // endregion

    // region Margin
    // TODO:KB 15/11/2024 margin would need to be handled differently
    // since it would appear outside the background
    'm': (child, parts) {
      return Padding(
        padding: EdgeInsets.all(parseToSpacing(parts)),
        child: child,
      );
    },
    'mx': (child, parts) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: parseToSpacing(parts)),
        child: child,
      );
    },
    'my': (child, parts) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: parseToSpacing(parts)),
        child: child,
      );
    },
    'mb': (child, parts) {
      return Padding(
        padding: EdgeInsets.only(bottom: parseToSpacing(parts)),
        child: child,
      );
    },
    'mt': (child, parts) {
      return Padding(
        padding: EdgeInsets.only(top: parseToSpacing(parts)),
        child: child,
      );
    },
    'ml': (child, parts) {
      return Padding(
        padding: EdgeInsets.only(left: parseToSpacing(parts)),
        child: child,
      );
    },
    'mr': (child, parts) {
      return Padding(
        padding: EdgeInsets.only(right: parseToSpacing(parts)),
        child: child,
      );
    },
    // endregion

    // region gap

    // endregion

    // region bg-color
    'bg': (child, parts) {
      dpl('bg: $parts');
      final colorName = parts[0];
      switch (colorName) {
        case 'white':
          return DecoratedBox(
            decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
            child: child,
          );
        case 'black':
          return DecoratedBox(
            decoration: const BoxDecoration(color: Color(0xFF000000)),
            child: child,
          );
        default:
          final colorRange = colors[colorName];
          if (colorRange == null) {
            dpl('Unknown color: $colorName');
            return child;
          }

          String? colorVariantName;
          if (parts.length > 1) {
            colorVariantName = parts[1];
          }

          if (colorVariantName == null) {
            dpl('No color variant specified for $colorName');
            return child;
          }

          final int? colorVariant = int.tryParse(colorVariantName);
          if (colorVariant == null) {
            dpl('Invalid color variant specified for $colorName: $colorVariantName');
            return child;
          }

          final color = colorRange[colorVariant];
          if (color == null) {
            dpl('Unknown color variant $colorVariant for $colorName');
            return child;
          }

          return DecoratedBox(
            decoration: BoxDecoration(
              color: color,
            ),
            child: child,
          );
      }
    },
    // endregion
  };

  // assumes list already validated and first part removed
  static double parseToSpacing(List<String> parts) {
    final valueStr = parts.first;
    //TODO:KB 15/11/2024 handle custom values in [] brackets, e.g. [24px]

    return double.parse(valueStr) * spacingMultiplier;
  }

  Widget parse(String className, List<Widget> children) {
    final classes = className.split(' ');

    if (classes.contains('hidden')) {
      return const SizedBox.shrink();
    }

    // Group classes by their type
    final classGroups = ClassGroups.fromClasses(classes);

    // Configure the layout first by processing all layout classes together
    Widget child = _buildFlexLayout(classGroups.layout, children);

    // Apply remaining classes in order
    for (final c in classGroups.internalSpacing) {
      child = _applyClass(c, child);
    }

    for (final c in classGroups.visual) {
      child = _applyClass(c, child);
    }

    for (final c in classGroups.margin) {
      child = _applyClass(c, child);
    }

    child = _applySizeClasses(classGroups.size, child);

    return child;
  }

  Widget _applySizeClasses(List<String> cs, Widget child) {
    if (cs.isEmpty) return child;

    // TODO:KB 15/11/2024 handle custom values in [] brackets, e.g. [24px]

    double? width;
    double? height;

    for (final c in cs) {
      final parts = c.split('-');
      if (parts.length == 1) continue;

      final key = parts[0];
      final value = parts[1];

      if (key == 'w') {
        // handle full width
        if (value == 'full') {
          width = double.infinity;
        } else {
          width = double.tryParse(value);
        }
      } else if (key == 'h') {
        if (value == 'full') {
          height = double.infinity;
        } else {
          height = double.tryParse(value);
        }
      }
    }

    if (width != null) {
      width *= spacingMultiplier;
    }

    if (height != null) {
      height *= spacingMultiplier;
    }

    // dpl('width: $width, height: $height');

    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }

  Widget _applyClass(String className, Widget child) {
    final parts = className.split('-');
    if (parts.length == 1) return child;

    final key = parts[0];
    final sublist = parts.sublist(1);
    if (sublist.isEmpty) return child;

    final fun = classNameLookup[key];
    if (fun == null) {
      dpl('Unknown class: $key');
      if (kDebugMode) {
        throw FWUnknownClassException('Unknown class: $key');
      }
      return child;
    }

    return fun(child, sublist);
  }

  Widget _buildFlexLayout(
    List<String> layoutClasses,
    List<Widget> children,
  ) {
    dpl('layoutClasses: $layoutClasses');

    final axis = findValueForClass(
      layoutClasses,
      ClassGroups.axis,
      Axis.horizontal,
    );

    return Flex(
      direction: axis,
      mainAxisAlignment: findValueForClass(
        layoutClasses,
        ClassGroups.mainAxisAlignment,
        MainAxisAlignment.start,
      ),
      mainAxisSize: findValueForClass(
        layoutClasses,
        ClassGroups.mainAxisSize,
        MainAxisSize.max,
      ),
      crossAxisAlignment: findValueForClass(
        layoutClasses,
        ClassGroups.crossAxisAlignment,
        CrossAxisAlignment.center,
      ),
      verticalDirection: findValueForClass(
        layoutClasses,
        ClassGroups.verticalDirection,
        VerticalDirection.down,
      ),
      children: addGaps(
        children,
        layoutClasses,
        axis,
      ),
    );
  }
}

List<Widget> addGaps(
  List<Widget> children,
  List<String> classes,
  Axis axis,
) {
  final gaps = classes.where((c) => c.startsWith('gap-')).toList();
  if (gaps.isEmpty) return children;

  final gap = gaps.first;
  final parts = gap.split('-');
  if (parts.length != 2) return children;

  var gapSize = double.tryParse(parts[1]);
  if (gapSize == null) return children;

  gapSize *= ClassParser.spacingMultiplier;
  final gapWidget = axis == Axis.horizontal
      ? SizedBox(width: gapSize)
      : SizedBox(height: gapSize);

  final newChildren = <Widget>[];

  for (var i = 0; i < children.length; i++) {
    newChildren.add(children[i]);
    if (i < children.length - 1) {
      newChildren.add(gapWidget);
    }
  }

  return newChildren;
}

T findValueForClass<T>(
  List<String> classNames,
  Map<String, T> lookup,
  T defaultValue,
) {
  for (final className in classNames) {
    final value = lookup[className];
    if (value != null) {
      return value;
    }
  }

  return defaultValue;
}
