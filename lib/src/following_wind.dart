import 'package:flutter/widgets.dart';

typedef FollowingWindConfig = ({
  double? spacingScale,
});

const spacingScaleDefault = 4.0;

class FollowingWind extends StatefulWidget {
  final Widget child;
  final FollowingWindConfig? config;

  const FollowingWind({
    super.key,
    required this.child,
    this.config,
  });

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

  @override
  State<FollowingWind> createState() => FollowingWindState();
}

typedef FollowingWindData = ({
  double spacingScale,
});

class FollowingWindState extends State<FollowingWind> {
  FollowingWindData data = (spacingScale: spacingScaleDefault,);

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
