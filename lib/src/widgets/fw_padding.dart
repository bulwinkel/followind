import 'package:flutter/widgets.dart';
import 'package:following_wind/following_wind.dart';
import 'package:following_wind/src/support_internal.dart';

class FwPadding extends StatelessWidget {
  static const classTypesPadding = ['p', 'px', 'py', 'pt', 'pr', 'pb', 'pl'];
  static const classTypesMargin = ['m', 'mx', 'my', 'mt', 'mr', 'mb', 'ml'];

  const FwPadding({
    super.key,
    required this.classTypes,
    required this.edgeInsets,
    required this.classes,
    required this.child,
  });

  final List<String> classTypes;
  final Map<String, BLRT<double>> edgeInsets;
  final List<String> classes;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    EdgeInsets? result;
    final FollowingWindData fw = FollowingWind.of(context);
    final sizeClasses = fw.sizeClasses;
    final parsedClasses = parseClasses(
      classes: classes,
      classTypes: classTypes,
      sizeClasses: sizeClasses,
    );

    for (final parsed in parsedClasses) {
      final applyAtWidth = parsed.applyAtWidth;
      if (applyAtWidth != 0.0 &&
          MediaQuery.sizeOf(context).width < applyAtWidth) {
        continue;
      }

      final maybeValue = edgeInsets["${parsed.type}-${parsed.value}"];
      if (maybeValue == null) {
        continue;
      }

      final (b, l, r, t) = maybeValue;

      // more specific classes override less specific ones
      // e.g. p-4 pl-0 should result in a padding of 4 on all sides
      // except left which should be 0
      result = result?.copyWith(
            bottom: b ?? result.bottom,
            left: l ?? result.left,
            right: r ?? result.right,
            top: t ?? result.top,
          ) ??
          EdgeInsets.only(
            bottom: b ?? 0,
            left: l ?? 0,
            right: r ?? 0,
            top: t ?? 0,
          );
    }

    if (result == null) {
      return child;
    }

    return Padding(
      padding: result,
      child: child,
    );
  }
}
