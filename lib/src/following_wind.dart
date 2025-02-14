import 'package:flutter/widgets.dart';
import 'package:following_wind/src/spacings.dart';

import 'colors.dart';
import 'styles/style.dart';
import 'support_internal.dart';

typedef FollowingWindConfig =
    ({
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

  const FollowingWind({super.key, this.config, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return _FollowingWind(config: config, screenSize: screenSize, child: child);
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

typedef FollowingWindData =
    ({
      Size screenSize,
      double spacingScale,

      /// The responsive modifiers that are currently active
      Map<String, double> sizeClasses,
      Map<String, Map<int, Color>> colors,
      Color borderColor,
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
    colors: {},
    borderColor: borderColorDefault,
  );

  void init() {
    final screenSize = widget.screenSize;
    dpl("[_FollowingWindState.init] screenSize: $screenSize");

    final config = widget.config;
    final spacingScale = config?.spacingScale ?? spacingScaleDefault;
    final borderColor = config?.borderColor ?? borderColorDefault;
    final borderWidth = config?.borderWidth ?? borderWidthDefault;

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
        colors: colors,
        borderColor: borderColor,
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
    final shouldReinit =
        oldWidget.config != widget.config ||
        oldWidget.screenSize != widget.screenSize;

    if (shouldReinit) {
      init();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _FollowingWindScope(data: data, child: widget.child);
  }
}

class _FollowingWindScope extends InheritedWidget {
  final FollowingWindData data;

  const _FollowingWindScope({required this.data, required super.child});

  @override
  bool updateShouldNotify(_FollowingWindScope oldWidget) {
    return data != oldWidget.data;
  }
}
