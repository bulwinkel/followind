import 'package:flutter/widgets.dart';
import 'package:following_wind/src/spacings.dart';

import 'colors.dart';
import 'support_internal.dart';

typedef FollowingWindConfig = ({
  /// e.g. 4.0 for 4px
  double? spacingScale,

  /// color to use for base `border` class
  Color? borderColor,

  /// value for default border width
  double? borderWidth,

  /// value for default 'rounded' class
  double? borderRadius,
});

const spacingScaleDefault = 4.0;
const borderColorDefault = Color(0xffe2e8f0); //colors['gray']![200]!;
const borderWidthDefault = 1.0;
const borderRadiusDefault = spacingScaleDefault;

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

  /// The responsive modifiers that are currently active
  Map<String, double> sizeClasses,
  Map<String, Size> sizes,
  Map<String, double> widths,
  Map<String, double> heights,
  Map<String, BLRT<double>> paddings,
  Map<String, BLRT<double>> margins,
  Map<String, Color> bgColors,
  Color borderColor,
  Map<String, BLRT<Color>> borderColors,
  Map<String, BLRT<double>> borderWidths,
  Map<String, Corners<double>> borderRadiuses,
});

class _FollowingWindState extends State<_FollowingWind> {
  FollowingWindData data = const (
    spacingScale: spacingScaleDefault,
    sizeClasses: {},
    sizes: {},
    widths: {},
    heights: {},
    paddings: {},
    margins: {},
    bgColors: {},
    borderColor: borderColorDefault,
    borderColors: {},
    borderWidths: {},
    borderRadiuses: {},
  );

  void init() {
    final screenSize = widget.screenSize;
    dpl("[_FollowingWindState.init] screenSize: $screenSize");

    final config = widget.config;
    final spacingScale = config?.spacingScale ?? spacingScaleDefault;
    final borderColor = config?.borderColor ?? borderColorDefault;
    final borderWidth = config?.borderWidth ?? borderWidthDefault;

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

    const borderWidths = {
      '0': 0.0,
      '1': 1.0,
      '2': 2.0,
      '4': 4.0,
      '8': 8.0,
    };

    final borderRadiusSizes = {
      'none': 0.0,
      'sm': spacingScale,
      'md': spacingScale * 1.5,
      'lg': spacingScale * 2,
      'xl': spacingScale * 3,
      '2xl': spacingScale * 4,
      '3xl': spacingScale * 6,
      'full': double.infinity,
    };

    final sizeClasses = {
      'sm': 640.0,
      'md': 768.0,
      'lg': 1024.0,
      'xl': 1280.0,
      '2xl': 1536.0,
    };

    setState(() {
      data = (
        spacingScale: spacingScale,
        sizeClasses: sizeClasses,
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
        bgColors: {
          'bg-white': white,
          'bg-black': black,
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'bg-${entry.key}-${shade.key}': shade.value,
        },
        borderColor: borderColor,
        borderColors: {
          'border': blrtAll(borderColor),
          'border-black': blrtAll(black),
          'border-white': blrtAll(white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'border-${entry.key}-${shade.key}': blrtAll(shade.value),
          // x
          'border-x': blrtSymmetric(horizontal: borderColor),
          'border-x-black': blrtSymmetric(horizontal: black),
          'border-x-white': blrtSymmetric(horizontal: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'border-x-${entry.key}-${shade.key}':
                  blrtSymmetric(horizontal: shade.value),
          // y
          'border-y': blrtSymmetric(vertical: borderColor),
          'border-y-black': blrtSymmetric(vertical: black),
          'border-y-white': blrtSymmetric(vertical: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'border-y-${entry.key}-${shade.key}':
                  blrtSymmetric(vertical: shade.value),
          // bottom
          'border-b': blrtOnly(bottom: borderColor),
          'border-b-black': blrtOnly(bottom: black),
          'border-b-white': blrtOnly(bottom: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'border-b-${entry.key}-${shade.key}':
                  blrtOnly(bottom: shade.value),
          // left
          'border-l': blrtOnly(left: borderColor),
          'border-l-black': blrtOnly(left: black),
          'border-l-white': blrtOnly(left: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'border-l-${entry.key}-${shade.key}': blrtOnly(left: shade.value),
          // right
          'border-r': blrtOnly(right: borderColor),
          'border-r-black': blrtOnly(right: black),
          'border-r-white': blrtOnly(right: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'border-r-${entry.key}-${shade.key}':
                  blrtOnly(right: shade.value),
          // top
          'border-t': blrtOnly(top: borderColor),
          'border-t-black': blrtOnly(top: black),
          'border-t-white': blrtOnly(top: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'border-t-${entry.key}-${shade.key}': blrtOnly(top: shade.value),
        },
        borderWidths: {
          'border': blrtAll(borderWidth),
          for (final entry in borderWidths.entries)
            'border-${entry.key}': blrtAll(entry.value),
          // x
          'border-x': blrtSymmetric(horizontal: borderWidth),
          for (final entry in borderWidths.entries)
            'border-x-${entry.key}': blrtSymmetric(horizontal: entry.value),
          // y
          'border-y': blrtSymmetric(vertical: borderWidth),
          for (final entry in borderWidths.entries)
            'border-y-${entry.key}': blrtSymmetric(vertical: entry.value),
          // bottom
          'border-b': blrtOnly(bottom: borderWidth),
          for (final entry in borderWidths.entries)
            'border-b-${entry.key}': blrtOnly(bottom: entry.value),
          // left
          'border-l': blrtOnly(left: borderWidth),
          for (final entry in borderWidths.entries)
            'border-l-${entry.key}': blrtOnly(left: entry.value),
          // right
          'border-r': blrtOnly(right: borderWidth),
          for (final entry in borderWidths.entries)
            'border-r-${entry.key}': blrtOnly(right: entry.value),
          // top
          'border-t': blrtOnly(top: borderWidth),
          for (final entry in borderWidths.entries)
            'border-t-${entry.key}': blrtOnly(top: entry.value),
        },
        borderRadiuses: {
          // all
          'rounded': cornersAll(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-${entry.key}': cornersAll(entry.value),

          // bottom
          'rounded-b': cornersBottom(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-b-${entry.key}': cornersBottom(entry.value),

          // left
          'rounded-l': cornersLeft(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-l-${entry.key}': cornersLeft(entry.value),

          // right
          'rounded-r': cornersRight(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-r-${entry.key}': cornersRight(entry.value),

          // top
          'rounded-t': cornersTop(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-t-${entry.key}': cornersTop(entry.value),

          // bottom left
          'rounded-bl': cornersOnly(bottomLeft: borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-bl-${entry.key}': cornersOnly(bottomLeft: entry.value),

          // bottom right
          'rounded-br': cornersOnly(bottomRight: borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-br-${entry.key}': cornersOnly(bottomRight: entry.value),

          // top left
          'rounded-tl': cornersOnly(topLeft: borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-tl-${entry.key}': cornersOnly(topLeft: entry.value),

          // top right
          'rounded-tr': cornersOnly(topRight: borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'rounded-tr-${entry.key}': cornersOnly(topRight: entry.value),
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
