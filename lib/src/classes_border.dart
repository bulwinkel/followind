import 'package:flutter/material.dart';
import 'package:following_wind/following_wind.dart';
import 'package:following_wind/src/support.dart';

const border = 'border';

typedef BLRT<T> = (T? b, T? l, T? r, T? t);

final Map<String, BLRT<double>> widthLookupTable = {
  'border': (1.0, 1.0, 1.0, 1.0),
  for (final size in classesBorderWidth)
    'border-$size': (
      double.parse(size),
      double.parse(size),
      double.parse(size),
      double.parse(size)
    ),
  'border-x': (null, 1.0, 1.0, null),
  for (final size in classesBorderWidth)
    'border-x-$size': (null, double.parse(size), double.parse(size), null),
  'border-y': (1.0, null, null, 1.0),
  for (final size in classesBorderWidth)
    'border-y-$size': (double.parse(size), null, null, double.parse(size)),
  'border-b': (1.0, null, null, null),
  for (final size in classesBorderWidth)
    'border-b-$size': (double.parse(size), null, null, null),
  'border-l': (null, 1.0, null, null),
  for (final size in classesBorderWidth)
    'border-l-$size': (null, double.parse(size), null, null),
  'border-r': (null, null, 1.0, null),
  for (final size in classesBorderWidth)
    'border-r-$size': (null, null, double.parse(size), null),
  'border-t': (null, null, null, 1.0),
  for (final size in classesBorderWidth)
    'border-t-$size': (null, null, null, double.parse(size)),
};

final colorLookupTable = {
  'border': (
    colors['gray']![200]!,
    colors['gray']![200]!,
    colors['gray']![200]!,
    colors['gray']![200]!
  ),
  'border-black': (Colors.black, Colors.black, Colors.black, Colors.black),
  'border-white': (Colors.white, Colors.white, Colors.white, Colors.white),
  for (final color in colors.entries)
    for (final shade in color.value.entries)
      'border-${color.key}-${shade.key}': (
        shade.value,
        shade.value,
        shade.value,
        shade.value
      ),
  'border-x-black': (null, Colors.black, Colors.black, null),
  'border-x-white': (null, Colors.white, Colors.white, null),
  for (final color in colors.entries)
    for (final shade in color.value.entries)
      'border-x-${color.key}-${shade.key}': (
        null,
        shade.value,
        shade.value,
        null,
      ),
  'border-y-black': (Colors.black, null, null, Colors.black),
  'border-y-white': (Colors.white, null, null, Colors.white),
  for (final color in colors.entries)
    for (final shade in color.value.entries)
      'border-y-${color.key}-${shade.key}': (
        shade.value,
        null,
        null,
        shade.value,
      ),
  'border-b-black': (Colors.black, null, null, null),
  'border-b-white': (Colors.white, null, null, null),
  for (final color in colors.entries)
    for (final shade in color.value.entries)
      'border-b-${color.key}-${shade.key}': (
        shade.value,
        null,
        null,
        null,
      ),
  'border-l-black': (null, Colors.black, null, null),
  'border-l-white': (null, Colors.white, null, null),
  for (final color in colors.entries)
    for (final shade in color.value.entries)
      'border-l-${color.key}-${shade.key}': (
        null,
        shade.value,
        null,
        null,
      ),
  'border-r-black': (null, null, Colors.black, null),
  'border-r-white': (null, null, Colors.white, null),
  for (final color in colors.entries)
    for (final shade in color.value.entries)
      'border-r-${color.key}-${shade.key}': (
        null,
        null,
        shade.value,
        null,
      ),
  'border-t-black': (null, null, null, Colors.black),
  'border-t-white': (null, null, null, Colors.white),
  for (final color in colors.entries)
    for (final shade in color.value.entries)
      'border-t-${color.key}-${shade.key}': (
        null,
        null,
        null,
        shade.value,
      ),
};

const classesBorderWidth = [
  '0',
  '1',
  '2',
  '4',
  '8',
];

final sortOrder = [
  border,
  ...classesBorderWidth.map((e) => 'border-$e'),
  ...colors.keys.map((e) => 'border-$e'),
];

Iterable<String> borderClasses(List<String> all) sync* {
  for (final c in all) {
    if (c.startsWith('border')) {
      yield c;
    }
  }
}

// borders need either straight `border` or a size for a size
// if no color defaults to gray-200
Border? processBorderClasses(List<String> classes) {
  double? lw;
  double? rw;
  double? top;
  double? bw;

  // lookup table is in the correct order so that more specific
  // classes override less specific ones
  for (final entry in widthLookupTable.entries) {
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

  dpl("$bw $lw $rw $top");

  var (bc, lc, rc, tc) = colorLookupTable[border]!;
  for (final entry in colorLookupTable.entries) {
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
