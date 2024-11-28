import 'package:flutter/painting.dart';

import '../colors.dart';
import '../parser.dart';
import '../support_internal.dart';

const border = 'border';

class BorderParser implements Parser<Border?> {
  BorderParser({
    required this.widths,
    required this.widthDefault,
    required this.colors,
    required this.colorDefault,
  });

  final List<String> widths;
  final double widthDefault;
  final Map<String, Map<int, Color>> colors;
  final Color colorDefault;

  late final Map<String, BLRT<double>> _widthLookup = {
    'border': (widthDefault, widthDefault, widthDefault, widthDefault),
    for (final size in widths)
      'border-$size': (
        double.parse(size),
        double.parse(size),
        double.parse(size),
        double.parse(size),
      ),
    'border-x': (
      null,
      widthDefault,
      widthDefault,
      null,
    ),
    for (final size in widths)
      'border-x-$size': (
        null,
        double.parse(size),
        double.parse(size),
        null,
      ),
    'border-y': (widthDefault, null, null, widthDefault),
    for (final size in widths)
      'border-y-$size': (
        double.parse(size),
        null,
        null,
        double.parse(size),
      ),
    'border-b': (widthDefault, null, null, null),
    for (final size in widths)
      'border-b-$size': (
        double.parse(size),
        null,
        null,
        null,
      ),
    'border-l': (null, widthDefault, null, null),
    for (final size in widths)
      'border-l-$size': (
        null,
        double.parse(size),
        null,
        null,
      ),
    'border-r': (null, null, widthDefault, null),
    for (final size in widths)
      'border-r-$size': (
        null,
        null,
        double.parse(size),
        null,
      ),
    'border-t': (null, null, null, widthDefault),
    for (final size in widths)
      'border-t-$size': (
        null,
        null,
        null,
        double.parse(size),
      ),
  };

  late final _colorLookup = {
    'border': (
      colorDefault,
      colorDefault,
      colorDefault,
      colorDefault,
    ),
    'border-black': (black, black, black, black),
    'border-white': (white, white, white, white),
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        'border-${color.key}-${shade.key}': (
          shade.value,
          shade.value,
          shade.value,
          shade.value
        ),
    'border-x-black': (null, black, black, null),
    'border-x-white': (null, white, white, null),
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        'border-x-${color.key}-${shade.key}': (
          null,
          shade.value,
          shade.value,
          null,
        ),
    'border-y-black': (black, null, null, black),
    'border-y-white': (white, null, null, white),
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        'border-y-${color.key}-${shade.key}': (
          shade.value,
          null,
          null,
          shade.value,
        ),
    'border-b-black': (black, null, null, null),
    'border-b-white': (white, null, null, null),
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        'border-b-${color.key}-${shade.key}': (
          shade.value,
          null,
          null,
          null,
        ),
    'border-l-black': (null, black, null, null),
    'border-l-white': (null, white, null, null),
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        'border-l-${color.key}-${shade.key}': (
          null,
          shade.value,
          null,
          null,
        ),
    'border-r-black': (null, null, black, null),
    'border-r-white': (null, null, white, null),
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        'border-r-${color.key}-${shade.key}': (
          null,
          null,
          shade.value,
          null,
        ),
    'border-t-black': (null, null, null, black),
    'border-t-white': (null, null, null, white),
    for (final color in colors.entries)
      for (final shade in color.value.entries)
        'border-t-${color.key}-${shade.key}': (
          null,
          null,
          null,
          shade.value,
        ),
  };

  // borders need either straight `border` or a size for a size
  // if no color defaults to gray-200
  @override
  Border? parse(List<String> classes) {
    double? lw;
    double? rw;
    double? top;
    double? bw;

    // lookup table is in the correct order so that more specific
    // classes override less specific ones
    for (final entry in _widthLookup.entries) {
      if (classes.contains(entry.key)) {
        final (b, l, r, t) = entry.value;
        // if we have already set a value and we get a null,
        // we leave the value unchanged
        bw = b ?? bw;
        lw = l ?? lw;
        rw = r ?? rw;
        top = t ?? top;
      }
    }

    // dpl("$bw $lw $rw $top");

    var (bc, lc, rc, tc) = _colorLookup[border]!;
    for (final entry in _colorLookup.entries) {
      if (classes.contains(entry.key)) {
        final (b, l, r, t) = entry.value;
        bc = b ?? bc;
        lc = l ?? lc;
        rc = r ?? rc;
        tc = t ?? tc;
      }
    }

    return Border(
      bottom: bw != null && bw > 0.0 && bc != null
          ? BorderSide(width: bw, color: bc)
          : BorderSide.none,
      left: lw != null && lw > 0.0 && lc != null
          ? BorderSide(width: lw, color: lc)
          : BorderSide.none,
      right: rw != null && rw > 0.0 && rc != null
          ? BorderSide(width: rw, color: rc)
          : BorderSide.none,
      top: top != null && top > 0.0 && tc != null
          ? BorderSide(width: top, color: tc)
          : BorderSide.none,
    );
  }
}
