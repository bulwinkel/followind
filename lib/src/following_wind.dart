import 'package:flutter/widgets.dart';
import 'package:following_wind/src/spacings.dart';

import 'colors.dart';
import 'styles/style.dart';
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
  Size screenSize,
  double spacingScale,

  /// The responsive modifiers that are currently active
  Map<String, double> sizeClasses,
  Map<String, double> spacings,
  Map<String, Size> fractionals,
  Map<String, BLRT<double>> paddings,
  Map<String, BLRT<double>> margins,
  Map<String, Map<int, Color>> colors,
  Map<String, Color> bgColors,
  Color borderColor,
  Map<String, BLRT<Color>> borderColors,
  Map<String, BLRT<double>> borderWidths,
  Map<String, Corners<double>> borderRadiuses,
});

extension FollowingWindDataX on FollowingWindData {
  double sizeForClass(SizeClass? className) {
    return sizeClasses[className?.name ?? ""] ?? 0.0;
  }
}

class _FollowingWindState extends State<_FollowingWind> {
  FollowingWindData data = const (
    screenSize: Size.zero,
    spacingScale: spacingScaleDefault,
    sizeClasses: {},
    spacings: {},
    fractionals: {},
    paddings: {},
    margins: {},
    colors: {},
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
      'xxl': 1536.0,
      '2xl': 1536.0,
    };

    setState(() {
      data = (
        screenSize: screenSize,
        spacingScale: spacingScale,
        sizeClasses: sizeClasses,
        spacings: spacingsCalculated,
        fractionals: fractionalSizesCalculated,
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
        colors: colors,
        bgColors: {
          'bg-white': white,
          'bg-black': black,
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'bg-${entry.key}-${shade.key}': shade.value,
        },
        borderColor: borderColor,
        borderColors: {
          '': blrtAll(borderColor),
          'black': blrtAll(black),
          'white': blrtAll(white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              '${entry.key}-${shade.key}': blrtAll(shade.value),
          // x
          'x': blrtSymmetric(horizontal: borderColor),
          'x-black': blrtSymmetric(horizontal: black),
          'x-white': blrtSymmetric(horizontal: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'x-${entry.key}-${shade.key}':
                  blrtSymmetric(horizontal: shade.value),
          // y
          'y': blrtSymmetric(vertical: borderColor),
          'y-black': blrtSymmetric(vertical: black),
          'y-white': blrtSymmetric(vertical: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'y-${entry.key}-${shade.key}':
                  blrtSymmetric(vertical: shade.value),
          // bottom
          'b': blrtOnly(bottom: borderColor),
          'b-black': blrtOnly(bottom: black),
          'b-white': blrtOnly(bottom: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'b-${entry.key}-${shade.key}': blrtOnly(bottom: shade.value),
          // left
          'l': blrtOnly(left: borderColor),
          'l-black': blrtOnly(left: black),
          'l-white': blrtOnly(left: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'l-${entry.key}-${shade.key}': blrtOnly(left: shade.value),
          // right
          'r': blrtOnly(right: borderColor),
          'r-black': blrtOnly(right: black),
          'r-white': blrtOnly(right: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              'r-${entry.key}-${shade.key}': blrtOnly(right: shade.value),
          // top
          't': blrtOnly(top: borderColor),
          't-black': blrtOnly(top: black),
          't-white': blrtOnly(top: white),
          for (final entry in colors.entries)
            for (final shade in entry.value.entries)
              't-${entry.key}-${shade.key}': blrtOnly(top: shade.value),
        },
        borderWidths: {
          '': blrtAll(borderWidth),
          for (final entry in borderWidths.entries)
            entry.key: blrtAll(entry.value),
          // x
          'x': blrtSymmetric(horizontal: borderWidth),
          for (final entry in borderWidths.entries)
            'x-${entry.key}': blrtSymmetric(horizontal: entry.value),
          // y
          'y': blrtSymmetric(vertical: borderWidth),
          for (final entry in borderWidths.entries)
            'y-${entry.key}': blrtSymmetric(vertical: entry.value),
          // bottom
          'b': blrtOnly(bottom: borderWidth),
          for (final entry in borderWidths.entries)
            'b-${entry.key}': blrtOnly(bottom: entry.value),
          // left
          'l': blrtOnly(left: borderWidth),
          for (final entry in borderWidths.entries)
            'l-${entry.key}': blrtOnly(left: entry.value),
          // right
          'r': blrtOnly(right: borderWidth),
          for (final entry in borderWidths.entries)
            'r-${entry.key}': blrtOnly(right: entry.value),
          // top
          't': blrtOnly(top: borderWidth),
          for (final entry in borderWidths.entries)
            't-${entry.key}': blrtOnly(top: entry.value),
        },
        borderRadiuses: {
          // all
          '': cornersAll(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            entry.key: cornersAll(entry.value),

          // bottom
          'b': cornersBottom(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'b-${entry.key}': cornersBottom(entry.value),

          // left
          'l': cornersLeft(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'l-${entry.key}': cornersLeft(entry.value),

          // right
          'r': cornersRight(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'r-${entry.key}': cornersRight(entry.value),

          // top
          't': cornersTop(borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            't-${entry.key}': cornersTop(entry.value),

          // bottom left
          'bl': cornersOnly(bottomLeft: borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'bl-${entry.key}': cornersOnly(bottomLeft: entry.value),

          // bottom right
          'br': cornersOnly(bottomRight: borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'br-${entry.key}': cornersOnly(bottomRight: entry.value),

          // top left
          'tl': cornersOnly(topLeft: borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'tl-${entry.key}': cornersOnly(topLeft: entry.value),

          // top right
          'tr': cornersOnly(topRight: borderRadiusDefault),
          for (final entry in borderRadiusSizes.entries)
            'tr-${entry.key}': cornersOnly(topRight: entry.value),
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
