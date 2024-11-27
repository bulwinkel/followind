import 'package:flutter/rendering.dart';

import '../parser.dart';
import '../support.dart';

class EdgeInsetsParser implements Parser<EdgeInsets?> {
  EdgeInsetsParser({
    required this.spacings,
    required this.multiplier,
  });

  final double multiplier;
  final List<String> spacings;

  // TODO:KB 27/11/2024 replace with BLRT so we can use null if not set
  // so we can override on each pass with more specific classes
  late final Map<String, BLRT<double?>> _lookup = {
    for (final size in spacings)
      'p-$size': (
        double.parse(size) * multiplier,
        double.parse(size) * multiplier,
        double.parse(size) * multiplier,
        double.parse(size) * multiplier
      ),
    for (final size in spacings)
      'px-$size': (
        double.parse(size) * multiplier,
        null,
        null,
        double.parse(size) * multiplier,
      ),
    for (final size in spacings)
      'py-$size': (
        null,
        double.parse(size) * multiplier,
        double.parse(size) * multiplier,
        null,
      ),
    for (final size in spacings)
      'pb-$size': (
        double.parse(size) * multiplier,
        null,
        null,
        null,
      ),
    for (final size in spacings)
      'pl-$size': (
        null,
        double.parse(size) * multiplier,
        null,
        null,
      ),
    for (final size in spacings)
      'pr-$size': (
        null,
        null,
        double.parse(size) * multiplier,
        null,
      ),
    for (final size in spacings)
      'pt-$size': (
        null,
        null,
        null,
        double.parse(size) * multiplier,
      ),

    // same for margin
    for (final size in spacings)
      'm-$size': (
        double.parse(size) * multiplier,
        double.parse(size) * multiplier,
        double.parse(size) * multiplier,
        double.parse(size) * multiplier,
      ),
    for (final size in spacings)
      'mx-$size': (
        double.parse(size) * multiplier,
        null,
        null,
        double.parse(size) * multiplier,
      ),
    for (final size in spacings)
      'my-$size': (
        null,
        double.parse(size) * multiplier,
        double.parse(size) * multiplier,
        null,
      ),
    for (final size in spacings)
      'mb-$size': (
        double.parse(size) * multiplier,
        null,
        null,
        null,
      ),
    for (final size in spacings)
      'ml-$size': (
        null,
        double.parse(size) * multiplier,
        null,
        null,
      ),
    for (final size in spacings)
      'mr-$size': (
        null,
        null,
        double.parse(size) * multiplier,
        null,
      ),
    for (final size in spacings)
      'mt-$size': (
        null,
        null,
        null,
        double.parse(size) * multiplier,
      ),
  };

  @override
  EdgeInsets? parse(List<String> classes) {
    // dpl('_lookup: $_lookup');

    EdgeInsets? result;

    for (final entry in _lookup.entries) {
      // more specific classes should override less specific ones
      // e.g. p-4 pl-0 should result in a padding of 4 on all sides
      // except left which should be 0
      if (classes.contains(entry.key)) {
        // dpl('entry: $entry');
        var (b, l, r, t) = entry.value;

        result = result?.copyWith(
              top: t ?? result.top,
              right: r ?? result.right,
              bottom: b ?? result.bottom,
              left: l ?? result.left,
            ) ??
            EdgeInsets.only(
              top: t ?? 0,
              right: r ?? 0,
              bottom: b ?? 0,
              left: l ?? 0,
            );
      }
    }

    return result;
  }
}
