import 'package:flutter/widgets.dart';

import 'followind_config.dart';

class Followind extends StatelessWidget {
  final FollowindConfig? config;
  final Widget child;

  const Followind({super.key, this.config, required this.child});

  @override
  Widget build(BuildContext context) {
    return _Followind(config: config, child: child);
  }

  // Find the nearest FollowindConfig or use the default one
  static FollowindConfig of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_FollowindScope>();
    return scope?.config ?? const FollowindConfig();
  }
}

class _Followind extends StatefulWidget {
  const _Followind({super.key, required this.child, this.config});

  final Widget child;
  final FollowindConfig? config;

  @override
  State<_Followind> createState() => _FollowindState();
}

class _FollowindState extends State<_Followind> {
  @override
  Widget build(BuildContext context) {
    return _FollowindScope(
      config: widget.config ?? const FollowindConfig(),
      child: widget.child,
    );
  }
}

class _FollowindScope extends InheritedWidget {
  final FollowindConfig config;

  const _FollowindScope({required this.config, required super.child});

  @override
  bool updateShouldNotify(_FollowindScope oldWidget) {
    return config != oldWidget.config;
  }
}
