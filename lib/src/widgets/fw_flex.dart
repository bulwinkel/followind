import 'package:flutter/widgets.dart';
import 'package:following_wind/following_wind.dart';
import 'package:following_wind/src/support_internal.dart';

class FwFlex extends StatelessWidget {
  static const axis = {
    'row': Axis.horizontal,
    'col': Axis.vertical,
  };

  static const mainAxisAlignment = {
    'main-start': MainAxisAlignment.start,
    'main-end': MainAxisAlignment.end,
    'main-center': MainAxisAlignment.center,
    'main-between': MainAxisAlignment.spaceBetween,
    'main-around': MainAxisAlignment.spaceAround,
    'main-evenly': MainAxisAlignment.spaceEvenly,
  };

  static const mainAxisSize = {
    'main-min': MainAxisSize.min,
    'main-max': MainAxisSize.max,
  };

  static const verticalDirection = {
    'vert-up': VerticalDirection.up,
    'vert-down': VerticalDirection.down,
  };

  static const crossAxisAlignment = {
    'cross-start': CrossAxisAlignment.start,
    'cross-end': CrossAxisAlignment.end,
    'cross-center': CrossAxisAlignment.center,
    'cross-stretch': CrossAxisAlignment.stretch,
    'cross-baseline': CrossAxisAlignment.baseline,
  };

  const FwFlex({
    super.key,
    required this.classes,
    required this.spacingMultiplier,
    required this.spacings,
    required this.children,
  });

  final List<String> classes;
  final double spacingMultiplier;
  final List<String> spacings;
  final List<Widget> children;

  List<Widget> withGaps(
    BuildContext context,
    Axis direction,
  ) {
    final FollowingWindData fw = FollowingWind.of(context);

    final List<ParsedClass> parsedClasses = parseClasses(
      classes: classes,
      classTypes: const ["gap"],
      sizeClasses: fw.sizeClasses,
    );
    // dpl("classes: $classes, parsedClasses: $parsedClasses");

    double? gapSize;

    for (final parsed in parsedClasses) {
      final applyAtWidth = parsed.applyAtWidth;
      if (applyAtWidth != 0.0 &&
          MediaQuery.sizeOf(context).width < applyAtWidth) {
        continue;
      }

      // override value from lower size class
      // if higher exists
      gapSize = fw.spacings[parsed.value] ?? gapSize;
    }

    if (gapSize == null) {
      return children;
    }

    final gapWidget = direction == Axis.horizontal
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

  T findValue<T>(
    BuildContext context,
    Map<String, T> lookup,
    T defaultValue,
  ) {
    final FollowingWindData fw = FollowingWind.of(context);

    final List<ParsedClass> parsed = parseClasses(
      classes: classes,
      classTypes: lookup.keys.toList(),
      sizeClasses: fw.sizeClasses,
    );
    // dpl("classes: $classes, parsed: $parsed");

    T result = defaultValue;

    for (final parsed in parsed) {
      final applyAtWidth = parsed.applyAtWidth;
      if (applyAtWidth != 0.0 &&
          MediaQuery.sizeOf(context).width < applyAtWidth) {
        continue;
      }

      result = lookup[parsed.type] ?? result;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final direction = findValue(
      context,
      axis,
      Axis.horizontal,
    );

    return Flex(
      direction: direction,
      mainAxisAlignment: findValue(
        context,
        mainAxisAlignment,
        MainAxisAlignment.start,
      ),
      mainAxisSize: findValue(
        context,
        mainAxisSize,
        MainAxisSize.max,
      ),
      crossAxisAlignment: findValue(
        context,
        crossAxisAlignment,
        CrossAxisAlignment.center,
      ),
      verticalDirection: findValue(
        context,
        verticalDirection,
        VerticalDirection.down,
      ),
      children: withGaps(context, direction),
    );
  }
}
