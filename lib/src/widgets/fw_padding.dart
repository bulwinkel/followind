import 'package:flutter/widgets.dart';
import 'package:following_wind/src/support_internal.dart';

class FwPadding extends StatelessWidget {
  const FwPadding({
    super.key,
    required this.edgeInsets,
    required this.classes,
    required this.child,
  });

  final Map<String, BLRT<double>> edgeInsets;
  final List<String> classes;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    EdgeInsets? result;

    for (final entry in edgeInsets.entries) {
      // more specific classes should override less specific ones
      // e.g. p-4 pl-0 should result in a padding of 4 on all sides
      // except left which should be 0
      if (classes.contains(entry.key)) {
        // dpl('entry: $entry');

        final (b, l, r, t) = entry.value;

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
