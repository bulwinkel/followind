import 'package:flutter/widgets.dart';
import 'package:following_wind/src/spacings.dart';

import 'support_internal.dart';

typedef FollowingWindConfig = ({
  double? spacingScale,
});

const spacingScaleDefault = 4.0;

const FollowingWindConfig kConfigDefault = (spacingScale: spacingScaleDefault,);

class FollowingWind extends StatelessWidget {
  final FollowingWindConfig? config;
  final Widget child;

  const FollowingWind({
    super.key,
    this.config,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return _FollowingWind(
      config: config,
      screenSize: screenSize,
      child: child,
    );
  }

  // Static method to access the config from anywhere in the widget tree
  static FollowingWindData of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_FollowingWindScope>();
    if (scope == null) {
      throw FlutterError(
        'FollowingWind.of() was called with a context that does not '
        'contain a FollowingWind widget.\n'
        'No FollowingWind widget ancestor could be found starting from '
        'the context that was passed to FollowingWind.of().\n'
        'The context used was:\n'
        '  $context',
      );
    }
    return scope.data;
  }
}

class _FollowingWind extends StatefulWidget {
  final Widget child;
  final FollowingWindConfig? config;
  final Size screenSize;

  const _FollowingWind({
    super.key,
    required this.child,
    this.config,
    required this.screenSize,
  });

  @override
  State<_FollowingWind> createState() => _FollowingWindState();
}

typedef FollowingWindData = ({
  double spacingScale,
  Map<String, Size> sizes,
  Map<String, double> widths,
  Map<String, double> heights,
  Map<String, BLRT<double>> paddings,
  Map<String, BLRT<double>> margins,
});

class _FollowingWindState extends State<_FollowingWind> {
  FollowingWindData data = const (
    spacingScale: spacingScaleDefault,
    sizes: {},
    widths: {},
    heights: {},
    paddings: {},
    margins: {},
  );

  void init() {
    final config = widget.config ?? kConfigDefault;
    final spacingScale = config.spacingScale ?? spacingScaleDefault;
    final screenSize = widget.screenSize;
    dpl("[_FollowingWindState.init] screenSize: $screenSize");

    // no prefix yet
    final spacingsCalculated = {
      for (final entry in spacings.entries)
        entry.key: entry.value * spacingScale,
    };

    final Map<String, Size> fractionalSizesCalculated = {
      'full': Size(double.infinity, double.infinity),
      for (final entry in fractionalSizes.entries)
        entry.key: Size(
          entry.value * screenSize.width,
          entry.value * screenSize.height,
        ),
    };

    final fractionalWidthsCalculated = {
      'full': double.infinity,
      for (final entry in fractionalSizes.entries)
        entry.key: entry.value * screenSize.width,
    };

    final Map<String, double> fractionalHeightsCalculated = {
      'full': double.infinity,
      for (final entry in fractionalSizes.entries)
        entry.key: entry.value * screenSize.height,
    };

    setState(() {
      data = (
        spacingScale: spacingScale,
        sizes: {
          for (final entry in spacingsCalculated.entries)
            'size-${entry.key}': Size(entry.value, entry.value),
          for (final entry in fractionalSizesCalculated.entries)
            'size-${entry.key}': entry.value,
        },
        widths: {
          for (final entry in spacingsCalculated.entries)
            'w-${entry.key}': entry.value,
          for (final entry in fractionalWidthsCalculated.entries)
            'w-${entry.key}': entry.value,
        },
        heights: {
          for (final entry in spacingsCalculated.entries)
            'h-${entry.key}': entry.value,
          for (final entry in fractionalHeightsCalculated.entries)
            'h-${entry.key}': entry.value,
        },
        paddings: {
          for (final entry in spacingsCalculated.entries)
            'p-${entry.key}': blrtAll(entry.value),
          for (final entry in spacingsCalculated.entries)
            'px-${entry.key}': blrtSymmetric(horizontal: entry.value),
          for (final entry in spacingsCalculated.entries)
            'py-${entry.key}': blrtSymmetric(vertical: entry.value),
          for (final entry in spacingsCalculated.entries)
            'pb-${entry.key}': blrtOnly(bottom: entry.value),
          for (final entry in spacingsCalculated.entries)
            'pl-${entry.key}': blrtOnly(left: entry.value),
          for (final entry in spacingsCalculated.entries)
            'pr-${entry.key}': blrtOnly(right: entry.value),
          for (final entry in spacingsCalculated.entries)
            'pt-${entry.key}': blrtOnly(top: entry.value),
        },
        margins: {
          for (final entry in spacingsCalculated.entries)
            'm-${entry.key}': blrtAll(entry.value),
          for (final entry in spacingsCalculated.entries)
            'mx-${entry.key}': blrtSymmetric(horizontal: entry.value),
          for (final entry in spacingsCalculated.entries)
            'my-${entry.key}': blrtSymmetric(vertical: entry.value),
          for (final entry in spacingsCalculated.entries)
            'mb-${entry.key}': blrtOnly(bottom: entry.value),
          for (final entry in spacingsCalculated.entries)
            'ml-${entry.key}': blrtOnly(left: entry.value),
          for (final entry in spacingsCalculated.entries)
            'mr-${entry.key}': blrtOnly(right: entry.value),
          for (final entry in spacingsCalculated.entries)
            'mt-${entry.key}': blrtOnly(top: entry.value),
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant _FollowingWind oldWidget) {
    final shouldReinit = oldWidget.config != widget.config ||
        oldWidget.screenSize != widget.screenSize;

    if (shouldReinit) {
      init();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _FollowingWindScope(
      data: data,
      child: widget.child,
    );
  }
}

class _FollowingWindScope extends InheritedWidget {
  final FollowingWindData data;

  const _FollowingWindScope({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_FollowingWindScope oldWidget) {
    return data != oldWidget.data;
  }
}
