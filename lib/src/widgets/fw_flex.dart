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

  FwFlex({
    super.key,
    required this.spacingMultiplier,
    required this.findValueForClass,
    required this.spacings,
    required this.children,
  });

  final double spacingMultiplier;
  final List<String> spacings;
  final T Function<T>(
    Map<String, T> lookup,
    T defaultValue,
  ) findValueForClass;
  final List<Widget> children;

  late final Map<String, double> _gaps = {
    for (final size in spacings)
      'gap-$size': double.parse(size) * spacingMultiplier,
  };

  List<Widget> withGaps(
    Axis direction,
  ) {
    final gapSize = findValueForClass(
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
