import 'package:flutter/widgets.dart';

class ClassGroups {
  static const sizeClasses = {
    'w',
    'h',
  };

  static const axis = {
    'row': Axis.horizontal,
    'col': Axis.vertical,
  };

  static const mainAxisAlignment = {
    'main-start': MainAxisAlignment.start,
    'main-end': MainAxisAlignment.end,
    'main-center': MainAxisAlignment.center,
    'main-between': MainAxisAlignment.spaceBetween,
    'main-around': MainAxisAlignment.spaceAround,
    'main-evenly': MainAxisAlignment.spaceEvenly,
  };

  static const mainAxisSize = {
    'main-min': MainAxisSize.min,
    'main-max': MainAxisSize.max,
  };

  static const verticalDirection = {
    'vert-up': VerticalDirection.up,
    'vert-down': VerticalDirection.down,
  };

  static const crossAxisAlignment = {
    'cross-start': CrossAxisAlignment.start,
    'cross-end': CrossAxisAlignment.end,
    'cross-center': CrossAxisAlignment.center,
    'cross-stretch': CrossAxisAlignment.stretch,
    'cross-baseline': CrossAxisAlignment.baseline,
  };

  // For now not going to replicate css flexbox since
  // the flutter flex widget works very differently.
  //
  // Instead we will add classes that represent the flutter
  // flex widget properties.
  static final layoutClasses = {
    ...axis.keys,
    ...mainAxisAlignment.keys,
    ...mainAxisSize.keys,
    ...verticalDirection.keys,
    ...crossAxisAlignment.keys,

    //TODO:KB 20/11/2024
    // 'flex-wrap',
    // 'flex-nowrap',
    // 'flex-grow',
    // 'flex-shrink',
  };

  // Prefixes for classes that need further parsing
  static const layoutPrefixes = {
    'gap',
  };

  static const internalSpacingPrefixes = {
    'p',
    'px',
    'py',
    'pt',
    'pb',
    'pl',
    'pr',
  };

  // TODO:KB 20/11/2024 create a parser for these classes
  // that builds a decorated box with the given properties
  static const visualPrefixes = {
    'bg',
    'border',
    'rounded',
  };

  static const marginPrefixes = {
    'm',
    'mx',
    'my',
    'mb',
    'mt',
    'ml',
    'mr',
  };

  final List<String> size;
  final List<String> layout;
  final List<String> internalSpacing;
  final List<String> visual;
  final List<String> margin;

  ClassGroups({
    required this.layout,
    required this.internalSpacing,
    required this.visual,
    required this.margin,
    required this.size,
  });

  factory ClassGroups.fromClasses(List<String> classes) {
    final layout = <String>[];
    final internalSpacing = <String>[];
    final visual = <String>[];
    final margin = <String>[];
    final size = <String>[];

    for (final c in classes) {
      // Check full class names first
      if (layoutClasses.contains(c)) {
        layout.add(c);
        continue;
      }

      // Then check prefixes for classes that need parsing
      final prefix = c.split('-')[0];

      if (layoutPrefixes.contains(prefix)) {
        layout.add(c);
        continue;
      }

      if (marginPrefixes.contains(prefix)) {
        margin.add(c);
        continue;
      }

      if (internalSpacingPrefixes.contains(prefix)) {
        internalSpacing.add(c);
        continue;
      }

      if (visualPrefixes.contains(prefix)) {
        visual.add(c);
        continue;
      }

      if (sizeClasses.contains(prefix)) {
        size.add(c);
        continue;
      }
    }

    return ClassGroups(
      layout: layout,
      internalSpacing: internalSpacing,
      visual: visual,
      margin: margin,
      size: size,
    );
  }
}
