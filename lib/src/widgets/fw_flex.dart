import 'package:flutter/widgets.dart';

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
    required this.spacingMultiplier,
    required this.classMap,
    required this.children,
  });

  final double spacingMultiplier;
  final Map<String, String> classMap;
  final List<Widget> children;

  T findValueForClass<T>(
    Map<String, T> lookup,
    T defaultValue,
  ) {
    T? result;

    for (final className in lookup.keys) {
      final value = classMap[className];
      if (value != null) {
        result = lookup[className];
      }
    }

    return result ?? defaultValue;
  }

  List<Widget> withGaps(
    Axis direction,
  ) {
    final gaps = classMap.keys.where((c) => c.startsWith('gap-')).toList();
    if (gaps.isEmpty) return children;

    final gap = gaps.first;
    final parts = gap.split('-');
    if (parts.length != 2) return children;

    var gapSize = double.tryParse(parts[1]);
    if (gapSize == null) return children;

    gapSize *= spacingMultiplier;
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

  @override
  Widget build(BuildContext context) {
    final direction = findValueForClass(
      axis,
      Axis.horizontal,
    );
    return Flex(
      direction: direction,
      mainAxisAlignment: findValueForClass(
        mainAxisAlignment,
        MainAxisAlignment.start,
      ),
      mainAxisSize: findValueForClass(
        mainAxisSize,
        MainAxisSize.max,
      ),
      crossAxisAlignment: findValueForClass(
        crossAxisAlignment,
        CrossAxisAlignment.center,
      ),
      verticalDirection: findValueForClass(
        verticalDirection,
        VerticalDirection.down,
      ),
      children: withGaps(direction),
    );
  }
}
