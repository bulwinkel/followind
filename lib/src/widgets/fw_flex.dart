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

  FwFlex({
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

  late final Map<String, double> _gaps = {
    for (final size in spacings)
      'gap-$size': double.parse(size) * spacingMultiplier,
  };

  List<Widget> withGaps(
    BuildContext context,
    Axis direction,
  ) {
    final gapSize = findValue(
      context,
      _gaps,
      null,
    );

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

    final List<ParsedClass> pAxis = parseClasses(
      classes: classes,
      classTypes: lookup.keys.toList(),
      sizeClasses: fw.sizeClasses,
    );
    // dpl("classes: $classes, pAxis: $pAxis");

    T result = defaultValue;

    for (final parsed in pAxis) {
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
